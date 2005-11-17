From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: Bad SCSI performance with 2.6.14 and Fusion-MPT
Date: Thu, 17 Nov 2005 10:58:15 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C04F853D8@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5EBA0.7B605930"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29902 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932455AbVKQR6d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 12:58:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Michael Renner <michael.renner@geizhals.at>, linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5EBA0.7B605930
Content-Type: text/plain

On  Thursday, November 17, 2005 10:08 AM, Alan D. Brunelle wrote:
> >Please use the patch I posted last night, apply to 2.6.15-rc1-git4.
> >It addresses this issue.  
> >
> >Here is the URL to this patch:
> >
> >http://marc.theaimsgroup.com/?l=linux-scsi&m=113219282408101&w=2
> >
> >Eric Moore
> >LSI Logic
> >
> >
> >  
> >
> FYI - I did try it earlier this morning with 2.6.14.2 and it 
> did *not* 
> fix the issue. I will see about updating to 2.6.15-rc1-git4, 
> and trying 
> that again...
> 

Ok, that make sense, I see your patch is handling mpt_config.

So with the patch I provided at the link above, can you apply
this patch over that. I've added the sync code in mpt_config.
Please let me know the results.  I also have a tool called 
getspeed that I can send you. It dump's the programmed
speed the devices were negotiated at.

Eric Moore




------_=_NextPart_000_01C5EBA0.7B605930
Content-Type: application/octet-stream;
	name="1a-perf-fix.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="1a-perf-fix.patch"

diff -uarN b/drivers/message/fusion/mptbase.c =
a/drivers/message/fusion/mptbase.c=0A=
--- b/drivers/message/fusion/mptbase.c	2005-11-16 18:19:11.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-11-17 10:43:18.000000000 =
-0700=0A=
@@ -5053,11 +5053,20 @@=0A=
 		return -EPERM;=0A=
 	}=0A=
 =0A=
+	if(mpt_alt_ioc_wait(ioc)!=3D0) {=0A=
+		dcprintk((MYIOC_s_WARN_FMT "alt_ioc busy!\n",=0A=
+		    ioc->name));=0A=
+		return -EBUSY;=0A=
+	}=0A=
+=0A=
 	/* Get and Populate a free Frame=0A=
 	 */=0A=
 	if ((mf =3D mpt_get_msg_frame(mpt_base_index, ioc)) =3D=3D NULL) {=0A=
 		dcprintk((MYIOC_s_WARN_FMT "mpt_config: no msg frames!\n",=0A=
 				ioc->name));=0A=
+		spin_lock(&ioc->initializing_hba_lock);=0A=
+		ioc->initializing_hba_lock_flag=3D0;=0A=
+		spin_unlock(&ioc->initializing_hba_lock);=0A=
 		return -EAGAIN;=0A=
 	}=0A=
 	pReq =3D (Config_t *)mf;=0A=
@@ -5139,6 +5148,10 @@=0A=
 	mpt_put_msg_frame(mpt_base_index, ioc, mf);=0A=
 	wait_event(mpt_waitq, pCfg->wait_done);=0A=
 =0A=
+	spin_lock(&ioc->initializing_hba_lock);=0A=
+	ioc->initializing_hba_lock_flag=3D0;=0A=
+	spin_unlock(&ioc->initializing_hba_lock);=0A=
+=0A=
 	/* mf has been freed - do not access */=0A=
 =0A=
 	rc =3D pCfg->status;=0A=

------_=_NextPart_000_01C5EBA0.7B605930--
