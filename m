From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] libfc: fix mem leak in fc_fcp_srr_resp()
Date: Fri, 29 Oct 2010 23:14:16 +0800
Message-ID: <AANLkTikSkLWU+Pf_dO9kBb0JYUMSFkj3AkOdXce2-rDN@mail.gmail.com>
References: <AANLkTik9+jAwcs0G9v2Nbwh-GfFc61V4=n7wYn0CaSc-@mail.gmail.com>
	<1288301999.1431.187.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57442 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab0J2POS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2010 11:14:18 -0400
Received: by eye27 with SMTP id 27so2192845eye.19
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2010 08:14:17 -0700 (PDT)
In-Reply-To: <1288301999.1431.187.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Fri, Oct 29, 2010 at 5:39 AM, Robert Love <robert.w.love@intel.com> =
wrote:
> On Mon, 2010-10-25 at 20:47 +0800, Hillf Danton wrote:
>> There seems frame should be freed against memory leakage.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 2010-09-13 07:07:38.=
000000000 +0800
>> +++ b/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 2010-10-25 20:33:58.=
000000000 +0800
>> @@ -1685,6 +1685,7 @@ static void fc_fcp_srr_resp(struct fc_se
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 if (fh->fh_type =3D=3D FC_TYPE_BLS) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fc_fcp_unlock_pkt(f=
sp);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fc_frame_free(fp);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> =C2=A0 =C2=A0 =C2=A0 }
>
> My first thought was that we need to do a fc_fcp_pkt_release here sin=
ce
> we're doing a fc_fcp_pkt_hold in fc_fcp_srr, but on further

Yes, the pkt hold should get dropped.

> consideration I think this BLS check is unnecessary. fc_exch_recv che=
cks
> for BLS frames before calling any of the response handlers.

If BLS encountered there is a chance in fc_exch_abts_resp() to call
response handler.
And fix looks like,

	if (fh->fh_type =3D=3D FC_TYPE_BLS) {
		fc_fcp_unlock_pkt(fsp);
+		fc_frame_free(fp);
+		fc_fcp_pkt_release(fsp);
		return;
	}

right?

//Hillf
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
