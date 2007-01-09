From: Manon Goo <manon@manon.de>
Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Tue, 09 Jan 2007 18:49:07 +0100
Message-ID: <186493B49C1E3D00EE38F0B8@eva.local>
References: <664A4EBB07F29743873A87CF62C26D704E90F8@NAMAIL4.ad.lsil.com>
 <45A3C00D.2030707@sgi.com>
Reply-To: Manon Goo <manon@manon.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="==========FC280AC2F1FDF8C48223=========="
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.dg-i.net ([195.49.152.199]:47938 "EHLO smtp.dg-i.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932338AbXAISXT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jan 2007 13:23:19 -0500
In-Reply-To: <45A3C00D.2030707@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, David Berghoff <david@dg-i.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, azimman@vmware.com, linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsi.com>

--==========FC280AC2F1FDF8C48223==========
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hmm .... why don't w make the whole thing configurable (david implemented=20
this for us)


+/*
+ *  cmd line parameters
+ */
+static int mpt_mpi_busy;
+module_param(mpt_mpi_busy, int, 0);
+MODULE_PARM_DESC(mpt_mpi_busy, " MPT MPI busy workaround for VMWare ESX=20
(default=3D0)");
+
 /*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
*/

 typedef struct _BIG_SENSE_BUF {
@@ -704,10 +711,13 @@
                        sc->resid=3D0;
                case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:        /* 0x0040 =
*/
                case MPI_IOCSTATUS_SUCCESS:                     /* 0x0000 =
*/
-                       if (scsi_status =3D=3D MPI_SCSI_STATUS_BUSY)
+                       if ((scsi_status =3D=3D MPI_SCSI_STATUS_BUSY) &&=20
!mpt_mpi_busy)
                                sc->result =3D (DID_BUS_BUSY << 16) |=20
scsi_status;
-                       else
+                       else {
+                                if (mpt_mpi_busy)
+                                        printk(KERN_INFO "MPT MPI ESX busy =

hack enabled ... waiting\n");
                                sc->result =3D (DID_OK << 16) | =
scsi_status;
+                        }
                        if (scsi_state =3D=3D 0) {
                                ;
                        } else if (scsi_state &=20
MPI_SCSI_STATE_AUTOSENSE_VALID) {



The prink(KERN... could be set if mpt_mpi_busy =3D=3D 2 to make debugging =
of=20
the situation optional

Manon

--On 9. Januar 2007 10:17:17 -0600 Michael Reed <mdr@sgi.com> wrote:

>
>
> Moore, Eric wrote:
>> On  Monday, January 08, 2007 3:25 PM, James Bottomley wrote:
>>
>>> Right, I sort of suspected something like this.  BUSY/QUEUE_FULL
>>> handling was a bit iffy in 2.4; but it was sorted out in the 2003/4
>>> timeframe.  Nowadays, I think you want to translate the
>>> MPI_SCSI_STATUS_BUSY directly to SAM_STAT_BUSY (i.e. just remove the
>>> special casing if).
>
> Christoph put in code to limit a command's lifetime to prevent infinite
> loops in the case of QUEUE_FULL and BUSY.  (See scsi_softirq_done()
> for implementation.)
>
> DID_OK / COMMAND_COMPLETE / BUSY results in a ADD_TO_MLQUEUE for a retry,
> same as QUEUE_FULL.  I don't infinite retries, just a whole lot of them.
> See scsi_decide_disposition().
>
> Mike
>
>>>
>>
>> I think your'e on the same page with the folks from VMware,
>> where the've asked us to go back to our old driver code.
>> Meaning we kill the check for "MPI_SCSI_STATUS_BUSY", instead the sam
>> status
>> is sent back "as is" without changing the DID_OK to DID_BUS_BUSY, etc.
>>
>> My problem with that is whether is breaks the Fibre Channel Folks.
>> Will FC failover solution work properly if we go back to the old code?
>> I add Stephen Shirron and Mike Reed.
>> I don't know.   Here is an explanation why that fix was needed back
>> about a year ago:
>>
>>
>> "When a target device responds with BUSY status, the MPT driver was
>> sending DID_OK to the
>> SCSI mid layer, which caused the IO to be retried indefinitely between
>> the mid layer and the
>> driver.  By changing the driver return status to DID_BUS_BUSY, the
>> target BUSY status can
>> now flow through the mid layer to an upper layer Failover driver, which
>> will manage the I/O timeout."
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>



Manon Goo
Dembach Goo Informatik GmbH & Co KG
Rathenauplatz 9
D-50674 K=C3=B6ln
Tel: +49 221 801483 0
Mobil: +49 177 8091974
Fax: +49 221 801483 20
Email: manon@dg-i.net


--==========FC280AC2F1FDF8C48223==========
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (Darwin)

iD8DBQFFo9WUGsjj3OYWNZERAhqGAKDj2gulFPkQp+7s3MRHxUDVQyF80wCg1M7P
pnSd4yAiTE9TkI6VQNxXb60=
=Uv4x
-----END PGP SIGNATURE-----

--==========FC280AC2F1FDF8C48223==========--

