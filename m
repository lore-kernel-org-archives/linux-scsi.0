Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EFBC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 16:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 101E42082E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 16:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgG2QoZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 12:44:25 -0400
Received: from comms.puri.sm ([159.203.221.185]:54404 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgG2QoZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 12:44:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id B78D1E044E;
        Wed, 29 Jul 2020 09:43:54 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TegbL7tiphgE; Wed, 29 Jul 2020 09:43:53 -0700 (PDT)
Date:   Wed, 29 Jul 2020 18:43:48 +0200
In-Reply-To: <1596037482.4356.37.camel@HansenPartnership.com>
References: <20200706164135.GE704149@rowland.harvard.edu> <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm> <20200728200243.GA1511887@rowland.harvard.edu> <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm> <20200729143213.GC1530967@rowland.harvard.edu> <1596033995.4356.15.camel@linux.ibm.com> <1596034432.4356.19.camel@HansenPartnership.com> <d9bb92e9-23fa-306f-c7f2-71a81ab28811@puri.sm> <1596037482.4356.37.camel@HansenPartnership.com>
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
Message-ID: <A1653792-B7E5-46A9-835B-7FA85FCD0378@puri.sm>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Am 29=2E Juli 2020 17:44:42 MESZ schrieb James Bottomley <James=2EBottomle=
y@HansenPartnership=2Ecom>:
>On Wed, 2020-07-29 at 17:40 +0200, Martin Kepplinger wrote:
>> On 29=2E07=2E20 16:53, James Bottomley wrote:
>> > On Wed, 2020-07-29 at 07:46 -0700, James Bottomley wrote:
>> > > On Wed, 2020-07-29 at 10:32 -0400, Alan Stern wrote:
>[=2E=2E=2E]
>> > > > This error report comes from the SCSI layer, not the block
>> > > > layer=2E
>> > >=20
>> > > That sense code means "NOT READY TO READY CHANGE, MEDIUM MAY HAVE
>> > > CHANGED" so it sounds like it something we should be
>> > > ignoring=2E  Usually this signals a problem, like you changed the
>> > > medium manually (ejected the CD)=2E  But in this case you can tell
>> > > us to expect this by setting
>> > >=20
>> > > sdev->expecting_cc_ua
>> > >=20
>> > > And we'll retry=2E  I think you need to set this on all resumed
>> > > devices=2E
>> >=20
>> > Actually, it's not quite that easy, we filter out this ASC/ASCQ
>> > combination from the check because we should never ignore medium
>> > might have changed events on running devices=2E  We could ignore it
>> > if we had a flag to say the power has been yanked (perhaps an
>> > additional sdev flag you set on resume) but we would still miss the
>> > case where you really had powered off the drive and then changed
>> > the media =2E=2E=2E if you can regard this as the user's problem, the=
n we
>> > might have a solution=2E
>> >=20
>> > James
>> > =20
>>=20
>> oh I see what you mean now, thanks for the ellaboration=2E
>>=20
>> if I do the following change, things all look normal and runtime pm
>> works=2E I'm not 100% sure if just setting expecting_cc_ua in resume()
>> is "correct" but that looks like it is what you're talking about:
>>=20
>> (note that this is of course with the one block layer diff applied
>> that Alan posted a few emails back)
>>=20
>>=20
>> --- a/drivers/scsi/scsi_error=2Ec
>> +++ b/drivers/scsi/scsi_error=2Ec
>> @@ -554,16 +554,8 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>>                  * so that we can deal with it there=2E
>>                  */
>>                 if (scmd->device->expecting_cc_ua) {
>> -                       /*
>> -                        * Because some device does not queue unit
>> -                        * attentions correctly, we carefully check
>> -                        * additional sense code and qualifier so as
>> -                        * not to squash media change unit attention=2E
>> -                        */
>> -                       if (sshdr=2Easc !=3D 0x28 || sshdr=2Eascq !=3D =
0x00)
>> {
>> -                               scmd->device->expecting_cc_ua =3D 0;
>> -                               return NEEDS_RETRY;
>> -                       }
>> +                       scmd->device->expecting_cc_ua =3D 0;
>> +                       return NEEDS_RETRY;
>
>Well, yes, but you can't do this because it would lose us media change
>events in the non-suspend/resume case which we really don't want=2E=20
>That's why I was suggesting a new flag=2E
>
>James

also if I set expecting_cc_ua in resume() only, like I did?

--=20
Martin Kepplinger
xmpp: martink@jabber=2Eat
Sent from mobile=2E
