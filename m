From: <vignesh.babu@wipro.com>
Subject: [KJ][PATCH]ch.c-kzalloc
Date: Mon, 16 Apr 2007 11:35:33 +0530
Message-ID: <1176703533.13066.10.camel@wriver-t81fb058.linuxcoe>
Mime-Version: 1.0
Content-Type: multipart/signed;
	micalg=sha1;
	protocol="application/x-pkcs7-signature";
	boundary="=-Dli1DCiTja+cXNN69ucQ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:49014 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbXDPGKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2007 02:10:02 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, kernel-janitors@lists.osdl.org


--=-Dli1DCiTja+cXNN69ucQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Replacing kmalloc/memset combination with kzalloc.

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 2a2cc6c..2311019 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -319,10 +319,9 @@ ch_readconfig(scsi_changer *ch)
 	int     result,id,lun,i;
 	u_int   elem;
=20
-	buffer =3D kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer =3D kzalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer)
 		return -ENOMEM;
-	memset(buffer,0,512);
 =09
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] =3D MODE_SENSE;
@@ -530,10 +529,9 @@ ch_set_voltag(scsi_changer *ch, u_int elem,
 	u_char  *buffer;
 	int result;
=20
-	buffer =3D kmalloc(512, GFP_KERNEL);
+	buffer =3D kzalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
-	memset(buffer,0,512);
=20
 	dprintk("%s %s voltag: 0x%x =3D> \"%s\"\n",
 		clear     ? "clear"     : "set",
@@ -922,11 +920,10 @@ static int ch_probe(struct device *dev)
 	if (sd->type !=3D TYPE_MEDIUM_CHANGER)
 		return -ENODEV;
    =20
-	ch =3D kmalloc(sizeof(*ch), GFP_KERNEL);
+	ch =3D kzalloc(sizeof(*ch), GFP_KERNEL);
 	if (NULL =3D=3D ch)
 		return -ENOMEM;
=20
-	memset(ch,0,sizeof(*ch));
 	ch->minor =3D ch_devcount;
 	sprintf(ch->name,"ch%d",ch->minor);
 	mutex_init(&ch->lock);

--=20
Regards, =20
Vignesh Babu BM =20
_____________________________________________________________ =20
"Why is it that every time I'm with you, makes me believe in magic?"

--=-Dli1DCiTja+cXNN69ucQ
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
DxcNMDcwNDE2MDYwNTMzWjAjBgkqhkiG9w0BCQQxFgQUrbI8kcd4UeFWLI7AFcJQ0VNhrW0wgYUG
CSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5n
IChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENB
AhAUQVpZzww0BCzlOIjOu/+QMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAj
BgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJz
b25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAUQVpZzww0BCzlOIjOu/+QMA0GCSqGSIb3DQEBAQUA
BIIBAMCQlvo6MxPgcxvx0gLwMQrgfEj3O30vnTj7Yt3oIWdjMCPRRrdpj6FSYHmDXVB7JKaaOHbW
bnpK9IeIexRbnDtIBvGDfRDa9bBrgk1GGio6e1Z07/WvHGCdgLl2yYgyIz3tmXoVgwnVMZHzivzb
8cSKYGyerCAsWkqA6UEbl2vUg/mYgTpMFO3+9mPYbzgOiNo5Rppf3rKbndyxdjVy7T30yhmSy3y+
NdegNb7qQakpjFzKGEHkf5nca/Wpr3OISXddvBEcZJPJbwP6u6x0KLBW6VpdIeC9IyLBzdqji/CH
Nn6DWahWElRBHErZyyeoErSqKTCvMbO/CjdfMDr/OX0AAAAAAAA=


--=-Dli1DCiTja+cXNN69ucQ--
