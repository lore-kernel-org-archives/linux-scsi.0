From: <vignesh.babu@wipro.com>
Subject: [KJ][PATCH]dpt_i2o.c-kzalloc
Date: Mon, 16 Apr 2007 11:35:38 +0530
Message-ID: <1176703538.13066.11.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
Content-Type: multipart/signed;
	micalg=sha1;
	protocol="application/x-pkcs7-signature";
	boundary="=-CIcEvWFqU8fUTOLYyzai"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:49029 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbXDPGKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2007 02:10:07 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org, kernel-janitors@lists.osdl.org


--=-CIcEvWFqU8fUTOLYyzai
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Replacing kmalloc/memset combination with kzalloc.

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index cd36e81..2184fcb 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1311,13 +1311,12 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
 		schedule_timeout_uninterruptible(1);
 	} while (m =3D=3D EMPTY_QUEUE);
=20
-	status =3D kmalloc(4, GFP_KERNEL|ADDR32);
+	status =3D kzalloc(4, GFP_KERNEL|ADDR32);
 	if(status =3D=3D NULL) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_ERR"IOP reset failed - no free memory.\n");
 		return -ENOMEM;
 	}
-	memset(status,0,4);
=20
 	msg[0]=3DEIGHT_WORD_MSG_SIZE|SGL_OFFSET_0;
 	msg[1]=3DI2O_CMD_ADAPTER_RESET<<24|HOST_TID<<12|ADAPTER_TID;
@@ -1507,21 +1506,19 @@ static int adpt_i2o_parse_lct(adpt_hba* pHba)
 					continue;
 				}
 				if( pHba->channel[bus_no].device[scsi_id] =3D=3D NULL){
-					pDev =3D  kmalloc(sizeof(struct adpt_device),GFP_KERNEL);
+					pDev =3D  kzalloc(sizeof(struct adpt_device),GFP_KERNEL);
 					if(pDev =3D=3D NULL) {
 						return -ENOMEM;
 					}
 					pHba->channel[bus_no].device[scsi_id] =3D pDev;
-					memset(pDev,0,sizeof(struct adpt_device));
 				} else {
 					for( pDev =3D pHba->channel[bus_no].device[scsi_id];=09
 							pDev->next_lun; pDev =3D pDev->next_lun){
 					}
-					pDev->next_lun =3D kmalloc(sizeof(struct adpt_device),GFP_KERNEL);
+					pDev->next_lun =3D kzalloc(sizeof(struct adpt_device),GFP_KERNEL);
 					if(pDev->next_lun =3D=3D NULL) {
 						return -ENOMEM;
 					}
-					memset(pDev->next_lun,0,sizeof(struct adpt_device));
 					pDev =3D pDev->next_lun;
 				}
 				pDev->tid =3D tid;
@@ -1670,12 +1667,11 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __=
user *arg)
 		reply_size =3D REPLY_FRAME_SIZE;
 	}
 	reply_size *=3D 4;
-	reply =3D kmalloc(REPLY_FRAME_SIZE*4, GFP_KERNEL);
+	reply =3D kzalloc(REPLY_FRAME_SIZE*4, GFP_KERNEL);
 	if(reply =3D=3D NULL) {
 		printk(KERN_WARNING"%s: Could not allocate reply buffer\n",pHba->name);
 		return -ENOMEM;
 	}
-	memset(reply,0,REPLY_FRAME_SIZE*4);
 	sg_offset =3D (msg[0]>>4)&0xf;
 	msg[2] =3D 0x40000000; // IOCTL context
 	msg[3] =3D (u32)reply;
@@ -2447,7 +2443,7 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 				}
 				pDev =3D pHba->channel[bus_no].device[scsi_id];=09
 				if( pDev =3D=3D NULL){
-					pDev =3D  kmalloc(sizeof(struct adpt_device),GFP_KERNEL);
+					pDev =3D  kzalloc(sizeof(struct adpt_device),GFP_KERNEL);
 					if(pDev =3D=3D NULL) {
 						return -ENOMEM;
 					}
@@ -2456,12 +2452,11 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 					while (pDev->next_lun) {
 						pDev =3D pDev->next_lun;
 					}
-					pDev =3D pDev->next_lun =3D kmalloc(sizeof(struct adpt_device),GFP_KE=
RNEL);
+					pDev =3D pDev->next_lun =3D kzalloc(sizeof(struct adpt_device),GFP_KE=
RNEL);
 					if(pDev =3D=3D NULL) {
 						return -ENOMEM;
 					}
 				}
-				memset(pDev,0,sizeof(struct adpt_device));
 				pDev->tid =3D d->lct_data.tid;
 				pDev->scsi_channel =3D bus_no;
 				pDev->scsi_id =3D scsi_id;

--=20
Regards, =20
Vignesh Babu BM =20
_____________________________________________________________ =20
"Why is it that every time I'm with you, makes me believe in magic?"

--=-CIcEvWFqU8fUTOLYyzai
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

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
CQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UE
AxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQAD
gY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow
1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNenpruf
ZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBD
BgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVl
bWFpbENBLmNybDALBgNVHQ8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVM
YWJlbDItMTM4MA0GCSqGSIb3DQEBBQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0wh
uPg2H6otnzYvwPQcUCCTcDz9reFhYsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBP
ZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIDEDCCAwwCAQEwdjBi
MQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoG
A1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEBRBWlnPDDQELOU4iM67
/5AwCQYFKw4DAhoFAKCCAW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMDcwNDE2MDYwNTM3WjAjBgkqhkiG9w0BCQQxFgQUnpQzvf+D2g1dFk8/mj7PdhxefLswgYUG
CSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5n
IChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENB
AhAUQVpZzww0BCzlOIjOu/+QMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAj
BgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJz
b25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAUQVpZzww0BCzlOIjOu/+QMA0GCSqGSIb3DQEBAQUA
BIIBAFCo5QiOxdoq+y9e3NZr7BktvfIlz/Shq9hEXsrvPGumJLW+KUc27emsCFpAyOUMjf7Z6LWj
DDzec0FgoR0W9ppX1eJo88YpPqc1rBS1RJAozhaGr+pbWOqGP70oHvPbhKviXsLoklAGLT75CKDk
CaARpO6tNZPKU7jca9edE7FGWYPQaGUoNtuMQ+AL7pc7wnFYxf0DyLawmlKNFD2v2xt7X7QyaRKU
qFczpCGCDdPG3hmSfw9/O9QYLlqrtg1h7anoHFT7TSRqY9p3cPVesJmCEDXVuJJxBALOzKpsTxZs
qgsZ42UG8wAVu5+eaN1zobboHJF5TJLD+QcG3udmgDcAAAAAAAA=


--=-CIcEvWFqU8fUTOLYyzai--
