From: Edward Goggin <egoggin@vmware.com>
Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Tue, 09 Jan 2007 16:32:37 -0500
Message-ID: <1168378357.8850.51.camel@egoggin-devd.eng.vmware.com>
References: <65B5F504434AD3469DC12E5564E3794D01EAB81D@PA-EXCH02.vmware.com>
	 <45A4014F.7070203@vmware.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-sw9vjHmYmKM/TA3HRyXb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:45906 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbXAIVdW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2007 16:33:22 -0500
In-Reply-To: <45A4014F.7070203@vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adam Zimman <azimman@vmware.com>, Petr Vandrovec <petr@vmware.com>, dgreen@vmware.com, Manon Goo <manon@manon.de>, Michael Reed <mdr@sgi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, David Berghoff <david@dg-i.net>, Vicky Xu <vgxu@vmware.com>, James Bottomley <James.Bottomley@SteelEye.com>, "Shirron, Stephen" <Stephen.Shirron@lsi.com>


--=-sw9vjHmYmKM/TA3HRyXb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-01-09 at 12:55 -0800, Petr Vandrovec wrote:
> Adam Zimman wrote:
> > Adding VMware engineering... 
> > 
> > -----Original Message-----
> > From: Manon Goo [mailto:manon@manon.de] 
> > Sent: Tuesday, January 09, 2007 9:49 AM
> > To: Michael Reed; Moore, Eric; David Berghoff
> > Cc: James Bottomley; Adam Zimman; linux-scsi@vger.kernel.org; Shirron, Stephen
> > Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
> > 
> > Hmm .... why don't w make the whole thing configurable (david implemented this for us)
> 
> In that case I would prefer going on with automatic detection of our 
> implementation - see first part of attached mpt-patch.diff I offered 
> when this all started.  As passing options to modules loaded by initrd 
> is not exactly trivial and varies across distributions, I would prefer 
> this runtime detection...
> 				Thanks,
> 					Petr Vandrovec
> 

The attached (untested) patch shows a VMware and scsi transport agnostic
approach which introduces a new host status (DID_QUALIFIED_REQUEUE) to
be used by mptscsih.c (and other LLDs) instead of DID_BUS_BUSY.  A host
status of DID_QUALIFIED_REQUEUE will return ADD_TO_MLQUEUE from
scsi_decide_disposition IFF the REQ_FAILFAST bit is not set in the
cmd_flags field of the SCSI command's request structure.

The approach depends on both VMware Linux guests not setting
REQ_FAILFAST and non-VMware Linux hosts with an IBM RDAC/MPP multi-
pathing driver doing so.  This requirement is not a problem for VMware
since its guest operating systems have no need to configure block device
multi-pathing.  This requirement shouldn't be a problem for the IBM
RDAC/MPP driver either since it should already be setting the
REQ_FAILFAST attribute of I/Os for which it is providing multi-pathing,
similar to what the Linux dm-multipath driver already does.

Ed Goggin

> > 
> > +/*
> > + *  cmd line parameters
> > + */
> > +static int mpt_mpi_busy;
> > +module_param(mpt_mpi_busy, int, 0);
> > +MODULE_PARM_DESC(mpt_mpi_busy, " MPT MPI busy workaround for VMWare ESX 
> > (default=0)");
> > +
> >  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> > 
> >  typedef struct _BIG_SENSE_BUF {
> > @@ -704,10 +711,13 @@
> >                         sc->resid=0;
> >                 case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:        /* 0x0040 */
> >                 case MPI_IOCSTATUS_SUCCESS:                     /* 0x0000 */
> > -                       if (scsi_status == MPI_SCSI_STATUS_BUSY)
> > +                       if ((scsi_status == MPI_SCSI_STATUS_BUSY) && 
> > !mpt_mpi_busy)
> >                                 sc->result = (DID_BUS_BUSY << 16) | 
> > scsi_status;
> > -                       else
> > +                       else {
> > +                                if (mpt_mpi_busy)
> > +                                        printk(KERN_INFO "MPT MPI ESX busy 
> > hack enabled ... waiting\n");
> >                                 sc->result = (DID_OK << 16) | scsi_status;
> > +                        }
> >                         if (scsi_state == 0) {
> >                                 ;
> >                         } else if (scsi_state & 
> > MPI_SCSI_STATE_AUTOSENSE_VALID) {
> plain text document attachment (mpt-patch.diff)
> Patch to fix timeouts during multi-path failover with LSILogic adapter on RedHat 4.0 Update 3 & 4.
> Patch is needed for other distributions as well - for example current Linus's 2.6.19 kernel needs it.
> 
> 
> diff -urN linux-2.6.9.orig/drivers/message/fusion/mptbase.c linux-2.6.9/drivers/message/fusion/mptbase.c
> --- linux-2.6.9.orig/drivers/message/fusion/mptbase.c	2006-12-15 11:13:47.000000000 -0800
> +++ linux-2.6.9/drivers/message/fusion/mptbase.c	2006-12-15 11:43:01.000000000 -0800
> @@ -1435,12 +1435,21 @@
>  		ioc->bus_type = SPI;
>  		/* 1030 Chip Fix. Disable Split transactions
>  		 * for PCIX. Set MOST bits to zero if Rev < C0( = 8).
> +		 *
> +		 * Also detect VMware's LSILogic emulation - it does
> +		 * not have PCI-X capability at offset 0x68 (and does
> +		 * not need disabling split transactions although it
> +		 * reports itself as revision 1).
>  		 */
>  		pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
>  		if (revision < C0_1030) {
> -			pci_read_config_byte(pdev, 0x6a, &pcixcmd);
> -			pcixcmd &= 0x8F;
> -			pci_write_config_byte(pdev, 0x6a, pcixcmd);
> +			if (pci_find_capability(pdev, PCI_CAP_ID_PCIX) == 0x68) {
> +				pci_read_config_byte(pdev, 0x6a, &pcixcmd);
> +				pcixcmd &= 0x8F;
> +				pci_write_config_byte(pdev, 0x6a, pcixcmd);
> +			} else {
> +				ioc->isVMware = 1;
> +			}
>  		}
>  	}
>  	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_1030_53C1035) {
> diff -urN linux-2.6.9.orig/drivers/message/fusion/mptbase.h linux-2.6.9/drivers/message/fusion/mptbase.h
> --- linux-2.6.9.orig/drivers/message/fusion/mptbase.h	2006-12-15 11:13:47.000000000 -0800
> +++ linux-2.6.9/drivers/message/fusion/mptbase.h	2006-12-15 11:40:47.000000000 -0800
> @@ -673,7 +673,8 @@
>  	u8			 upload_fw;	/* If set, do a fw upload */
>  	u8			 reload_fw;	/* Force a FW Reload on next reset */
>  	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  */
> -	u8			 pad1[4];
> +	u8			 isVMware;
> +	u8			 pad1[3];
>  	int			 DoneCtx;
>  	int			 TaskCtx;
>  	int			 InternalCtx;
> diff -urN linux-2.6.9.orig/drivers/message/fusion/mptscsi.c linux-2.6.9/drivers/message/fusion/mptscsi.c
> --- linux-2.6.9.orig/drivers/message/fusion/mptscsi.c	2006-12-15 11:13:47.000000000 -0800
> +++ linux-2.6.9/drivers/message/fusion/mptscsi.c	2006-12-15 11:49:18.000000000 -0800
> @@ -773,7 +773,12 @@
>  			sc->resid=0;
>  		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
>  		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
> -			if (scsi_status == MPI_SCSI_STATUS_BUSY)
> +			/*
> +			 * In the case of emulated adapter busy status may be reported 
> +			 * for minutes when storage path switch occurs in the firmware.
> +			 * We definitely do not want to give up after standard timeout.
> +			 */
> +			if (scsi_status == MPI_SCSI_STATUS_BUSY && !ioc->isVMware)
>  				sc->result = (DID_BUS_BUSY << 16) | scsi_status;
>  			else
>  				sc->result = (DID_OK << 16) | scsi_status;
> @@ -810,6 +815,7 @@
>  				 * Not real sure here either so do nothing...  */
>  			}
>  
> +			/* Perhaps this wanted to test scsi_status and not sc->result? */
>  			if (sc->result == MPI_SCSI_STATUS_TASK_SET_FULL)
>  				mptscsih_report_queue_full(sc, pScsiReply, pScsiReq);
>  

--=-sw9vjHmYmKM/TA3HRyXb
Content-Disposition: attachment; filename=vmware_patch
Content-Type: text/x-patch; name=vmware_patch; charset=utf-8
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgbGludXgtMi42LjIwLXJjMy9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21wdHNjc2lo
LmMgbGludXgtMi42LjIwLXJjMy52bXdhcmVfcGF0Y2gvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9t
cHRzY3NpaC5jDQotLS0gbGludXgtMi42LjIwLXJjMy9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21w
dHNjc2loLmMJMjAwNy0wMS0wOSAxNToxMDoyOC4wMDAwMTkwMDAgLTA1MDANCisrKyBsaW51eC0y
LjYuMjAtcmMzLnZtd2FyZV9wYXRjaC9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21wdHNjc2loLmMJ
MjAwNy0wMS0wOSAxNTo0NjoyNi4wMDAxMDUwMDAgLTA1MDANCkBAIC03NjksNyArNzY5LDcgQEAN
CiAJCWNhc2UgTVBJX0lPQ1NUQVRVU19TQ1NJX1JFQ09WRVJFRF9FUlJPUjoJLyogMHgwMDQwICov
DQogCQljYXNlIE1QSV9JT0NTVEFUVVNfU1VDQ0VTUzoJCQkvKiAweDAwMDAgKi8NCiAJCQlpZiAo
c2NzaV9zdGF0dXMgPT0gTVBJX1NDU0lfU1RBVFVTX0JVU1kpDQotCQkJCXNjLT5yZXN1bHQgPSAo
RElEX0JVU19CVVNZIDw8IDE2KSB8IHNjc2lfc3RhdHVzOw0KKwkJCQlzYy0+cmVzdWx0ID0gKERJ
RF9RVUFMSUZJRURfUkVRVUVVRSA8PCAxNikgfCBzY3NpX3N0YXR1czsNCiAJCQllbHNlDQogCQkJ
CXNjLT5yZXN1bHQgPSAoRElEX09LIDw8IDE2KSB8IHNjc2lfc3RhdHVzOw0KIAkJCWlmIChzY3Np
X3N0YXRlID09IDApIHsNCmRpZmYgLXJ1IGxpbnV4LTIuNi4yMC1yYzMvZHJpdmVycy9zY3NpL3Nj
c2lfZXJyb3IuYyBsaW51eC0yLjYuMjAtcmMzLnZtd2FyZV9wYXRjaC9kcml2ZXJzL3Njc2kvc2Nz
aV9lcnJvci5jDQotLS0gbGludXgtMi42LjIwLXJjMy9kcml2ZXJzL3Njc2kvc2NzaV9lcnJvci5j
CTIwMDctMDEtMDkgMTQ6NDA6MTYuMDAwMDIyMDAwIC0wNTAwDQorKysgbGludXgtMi42LjIwLXJj
My52bXdhcmVfcGF0Y2gvZHJpdmVycy9zY3NpL3Njc2lfZXJyb3IuYwkyMDA3LTAxLTA5IDE1OjU1
OjQ4LjAwMDA1MTAwMCAtMDUwMA0KQEAgLTEyMTYsNiArMTIxNiwxNCBAQA0KIAljYXNlIERJRF9J
TU1fUkVUUlk6DQogCQlyZXR1cm4gTkVFRFNfUkVUUlk7DQogDQorCWNhc2UgRElEX1FVQUxJRklF
RF9SRVFVRVVFOg0KKwkJLyoNCisJCSAqIFJldHVybiBpbW1lZGlhdGVseSB3L28gcmVxdWV1ZSBp
ZiB0aGUgcmVxdWVzdCANCisJCSAqIGluZGljYXRlcyBubyByZXRyeS4NCisJCSAqLw0KKwkJaWYg
KGJsa19ub3JldHJ5X3JlcXVlc3Qoc2NtZC0+cmVxdWVzdCkpIHsNCisJCQlyZXR1cm4gU1VDQ0VT
UzsNCisJCX0NCiAJY2FzZSBESURfUkVRVUVVRToNCiAJCXJldHVybiBBRERfVE9fTUxRVUVVRTsN
CiANCmRpZmYgLXJ1IGxpbnV4LTIuNi4yMC1yYzMvaW5jbHVkZS9zY3NpL3Njc2kuaCBsaW51eC0y
LjYuMjAtcmMzLnZtd2FyZV9wYXRjaC9pbmNsdWRlL3Njc2kvc2NzaS5oDQotLS0gbGludXgtMi42
LjIwLXJjMy9pbmNsdWRlL3Njc2kvc2NzaS5oCTIwMDctMDEtMDkgMTU6MDc6MzAuMDAwMDA5MDAw
IC0wNTAwDQorKysgbGludXgtMi42LjIwLXJjMy52bXdhcmVfcGF0Y2gvaW5jbHVkZS9zY3NpL3Nj
c2kuaAkyMDA3LTAxLTA5IDE1OjQ1OjQxLjAwMDA3NTAwMCAtMDUwMA0KQEAgLTMwOSw2ICszMDks
OCBAQA0KICNkZWZpbmUgRElEX0lNTV9SRVRSWSAgIDB4MGMJLyogUmV0cnkgd2l0aG91dCBkZWNy
ZW1lbnRpbmcgcmV0cnkgY291bnQgICovDQogI2RlZmluZSBESURfUkVRVUVVRQkweDBkCS8qIFJl
cXVldWUgY29tbWFuZCAobm8gaW1tZWRpYXRlIHJldHJ5KSBhbHNvDQogCQkJCSAqIHdpdGhvdXQg
ZGVjcmVtZW50aW5nIHRoZSByZXRyeSBjb3VudAkgICAqLw0KKyNkZWZpbmUgRElEX1FVQUxJRklF
RF9SRVFVRVVFIDB4MGUgLyogUmVxdWV1ZSBjbWQgdy9vIGRlY3Igb2YgcmV0cnkgY291bnQgSUZG
DQorCQkJCSAqIG5vdCBibGtfbm9yZXRyeV9yZXF1ZXN0CQkgICAqLw0KICNkZWZpbmUgRFJJVkVS
X09LICAgICAgIDB4MDAJLyogRHJpdmVyIHN0YXR1cyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICovDQogDQogLyoNCg==


--=-sw9vjHmYmKM/TA3HRyXb--
