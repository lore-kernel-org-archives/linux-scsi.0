From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym53c8xx driver hangs
Date: Fri, 18 Feb 2005 05:19:16 +0000
Message-ID: <20050218051916.GX29917@parcelfarce.linux.theplanet.co.uk>
References: <4214BD90.7030002@ludd.luth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:7306 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261232AbVBRFTT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 00:19:19 -0500
Content-Disposition: inline
In-Reply-To: <4214BD90.7030002@ludd.luth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roger =?iso-8859-1?Q?H=E5kansson?= <hson@ludd.luth.se>
Cc: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2005 at 04:51:44PM +0100, Roger H=E5kansson wrote:
> I've seen that there are more people having similar problem and some=20
> patches have also been suggested, but I haven't tested any of them ye=
t.

Yeah, I don't think any existing patch will help you.  Could you try
this one?

Index: drivers/scsi/sym53c8xx_2/sym_hipd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /var/lib/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.48
diff -u -p -r1.48 sym_hipd.c
--- drivers/scsi/sym53c8xx_2/sym_hipd.c 16 Feb 2005 20:54:02 -0000     =
 1.48
+++ drivers/scsi/sym53c8xx_2/sym_hipd.c 18 Feb 2005 05:14:51 -0000
@@ -2738,6 +2738,10 @@ unexpected_phase:
                         dsp =3D=3D SCRIPTB_BA (np, send_sdtr) ||
                         dsp =3D=3D SCRIPTB_BA (np, send_ppr)) {
                        nxtdsp =3D SCRIPTB_BA (np, nego_bad_phase);
+                       if (dsp =3D=3D SCRIPTB_BA(np, send_ppr)) {
+                               struct scsi_device *dev =3D cp->cam_ccb=
->device;
+                               dev->ppr =3D 0;
+                       }
                }
                break;
 #if 0

Basically, the drive is being Bad by acting as if PPR is a personal
insult even though it claims to be SCSI-3.  This should turn off future
attempts to negotiate with PPR after the first attempt fails.

--=20
"Next the statesmen will invent cheap lies, putting the blame upon=20
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refu=
se
to examine any refutations of them; and thus he will by and by convince=
=20
himself that the war is just, and will thank God for the better sleep=20
he enjoys after this process of grotesque self-deception." -- Mark Twai=
n
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
