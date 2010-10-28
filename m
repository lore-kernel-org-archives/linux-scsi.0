From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH 1/2] libfc: fix mem leak in fc_tm_done()
Date: Thu, 28 Oct 2010 21:47:11 +0800
Message-ID: <AANLkTimCUgAjH8SNQOrgp+a4QFh+4-rQ1vHepWj5f86c@mail.gmail.com>
References: <AANLkTinAOy9+WPuKGro09Cu=xiLF+QMQ+JkioHNZao9n@mail.gmail.com>
	<1288228701.1431.44.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40919 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758873Ab0J1NrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 09:47:13 -0400
Received: by wyf28 with SMTP id 28so1975750wyf.19
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 06:47:12 -0700 (PDT)
In-Reply-To: <1288228701.1431.44.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Thu, Oct 28, 2010 at 9:18 AM, Robert Love <robert.w.love@intel.com> =
wrote:
> On Mon, 2010-10-25 at 20:37 +0800, Hillf Danton wrote:
>> There seems frame should get freed against memory leakage.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 2010-09-13 07:07:38.=
000000000 +0800
>> +++ b/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 2010-10-25 20:31:04.=
000000000 +0800
>> @@ -1294,6 +1294,7 @@ static void fc_tm_done(struct fc_seq *se
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 if (!fsp->seq_ptr || !fsp->wait_for_comp) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&fsp=
->scsi_pkt_lock);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fc_frame_free(fp);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> =C2=A0 =C2=A0 =C2=A0 }
>> _______________________________________________
>> devel mailing list
>> devel@open-fcoe.org
>> http://www.open-fcoe.org/mailman/listinfo/devel
>
> Hi Hillf,
>
> =C2=A0 I'm not sure how you're generating your patches, but it seems =
that
> many of them (not sure if it's all) do not have a trailing whitespace
> line. So, when I try to apply the patch either using 'patch' or 'git-=
am'
> it sees the first line of the mailing list footer as part of the patc=
h.
> So the, "____________________" line is considered part of the patch a=
nd
> it causes the application of the patch to fail. Here's what happens w=
hen
> I try to apply the mbox for this patch.
>
> rwlove@fritz:/var/testspace/open-fcoe-initiator$ git-am
> ~/Desktop/1-2-libfc-fix-mem-leak-in-fc_tm_done.patch
> Applying: libfc: fix mem leak in fc_tm_done()
> fatal: corrupt patch at line 16
> Patch failed at 0001 libfc: fix mem leak in fc_tm_done()
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort"=
=2E
> rwlove@fritz:/var/testspace/open-fcoe-initiator$ patch -p1 --dry-run
> < .git/rebase-apply/0001
> patching file drivers/scsi/libfc/fc_fcp.c
> patch: **** malformed patch at line 28:
> _______________________________________________
>
>
> =C2=A0 I'm not a patch formatting expert, but I think the lack of a
> whitespace line at the end of the changes is the problem.
>
> =C2=A0 I'd suggest mailing the patch to yourself first and then try a=
pplying
> the mbox with 'git-am', if that works then everything should be fine.
>
> =C2=A0 Also, I like to use stgit to generate and mail patches. Everyo=
ne has
> their own development process, but I want to point that tool out to y=
ou
> because it will take care of all of the formatting for you.
>
> Thanks, //Rob

Sorry, get you in trouble again. More care will be taken. //Hillf
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
