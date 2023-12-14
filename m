Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BB72DF66
	for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 21:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="W3uvO2FP"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6d267461249so584228b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 13:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1702587662; x=1703192462; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=MdLtQ6r57qyKuA0ogKBq5zfOsRV+jdFJgmY9lNl5pGk=;
        b=W3uvO2FP410N/DqoU/lUQCVwficRFnDD28lkfXtmqgDJ0YAbCSb+v8mutUdeanZcVc
         fA7h8cJ4d7Wg+KgedMxxza7eXe3oQMDfhHJKOZ9wYDWAt6kW712/W0ok3IAZib1PlvoV
         AjE5cebxmqvCz1EZfEMEEiuBYxSrBx2qfccrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702587662; x=1703192462;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MdLtQ6r57qyKuA0ogKBq5zfOsRV+jdFJgmY9lNl5pGk=;
        b=BSIatwr0RzvHQyU/G/iVRvICRz7DEq5jz01iBwNLh3dnFeyq1W2B0V6jDh62oaYmYE
         9AcfykYXRPwpfpv3oNvEdTguv1Td4WJ2tGtuIlx9+ujUNP9bKfqBSltEYqsBQX90QDab
         9sAZgpTeHvIDg8O0twPyFmTvj/kFUW3TQ33RVSttB8KzLa2+joJ7vzg6+jOrKsxkTOzR
         4vnJC2YZEIJ7AgtGX94Ogbrqlw0NyysBUdzotgpETBLmC5jDTWXehH++n3E3z1/VHuxD
         HR/bcmLsCJib7Lm9nU1x+DB7leZzG+MtSi4yXdy2rKvZm8AcYSPgbRmxY1rENSH9JCPT
         s48Q==
X-Gm-Message-State: AOJu0Yx/N4WnfnkkLIad4LL825apkCCsj2uhA3xxOHAcNyPjOUyN/Aom
	b760EDskAJkCmXK/MKunRmMO8O+I6kYHfqZi2X131Cs724QBt6fRauGPKJ7EJmTdvkJSM6QyU/n
	l35ie3j4GAd1ngSCH0EB3ZT1f8zWHgDgA1xij2WV8qhProkzP8FSqWpvPh90AJGSGXB3UwD/ew6
	JMzMd6PAOvOw==
X-Google-Smtp-Source: AGHT+IE518HiBlXymt/MejxnVwizYC5xhHPpCrq5UH9/vVHGO01H7bTJu+IivEcNHPhZSKeoSNy4EA==
X-Received: by 2002:a05:6a00:4601:b0:6cb:6a27:ab57 with SMTP id ko1-20020a056a00460100b006cb6a27ab57mr5686252pfb.14.1702587662002;
        Thu, 14 Dec 2023 13:01:02 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id bv190-20020a632ec7000000b005c2967852c5sm11904303pgb.30.2023.12.14.13.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 13:01:01 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 1/6] mpi3mr: Creation of helper function
Date: Fri, 15 Dec 2023 02:28:55 +0530
Message-Id: <20231214205900.270488-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231214205900.270488-1-ranjan.kumar@broadcom.com>
References: <20231214205900.270488-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000d53335060c7e940b"

--000000000000d53335060c7e940b
Content-Transfer-Encoding: 8bit

Use of helper function to get controller and shost details.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 54 ++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 1bffd629c124..76ba31a9517d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5230,6 +5230,35 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return retval;
 }
 
+/**
+ * mpi3mr_get_shost_and_mrioc - get shost and ioc reference if
+ *                     they are valid
+ * @pdev: PCI device struct
+ * @shost: address to store scsi host reference
+ * @mrioc: address store HBA adapter reference
+ *
+ * Return: 0 if *shost and *ioc are not NULL otherwise -1.
+ */
+
+static int
+mpi3mr_get_shost_and_mrioc(struct pci_dev *pdev,
+	struct Scsi_Host **shost, struct mpi3mr_ioc **mrioc)
+{
+	*shost = pci_get_drvdata(pdev);
+	if (*shost == NULL) {
+		dev_err(&pdev->dev, "pdev's driver data is null\n");
+		return -ENXIO;
+	}
+
+	*mrioc = shost_priv(*shost);
+	if (*mrioc == NULL) {
+		dev_err(&pdev->dev, "shost's private data is null\n");
+		*shost = NULL;
+		return -ENXIO;
+		}
+	return 0;
+}
+
 /**
  * mpi3mr_remove - PCI remove callback
  * @pdev: PCI device instance
@@ -5242,7 +5271,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  */
 static void mpi3mr_remove(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
 	struct workqueue_struct	*wq;
 	unsigned long flags;
@@ -5250,7 +5279,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	struct mpi3mr_hba_port *port, *hba_port_next;
 	struct mpi3mr_sas_node *sas_expander, *sas_expander_next;
 
-	if (!shost)
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
 		return;
 
 	mrioc = shost_priv(shost);
@@ -5328,12 +5357,12 @@ static void mpi3mr_remove(struct pci_dev *pdev)
  */
 static void mpi3mr_shutdown(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 
-	if (!shost)
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
 		return;
 
 	mrioc = shost_priv(shost);
@@ -5361,17 +5390,19 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
  * Change the power state to the given value and cleanup the IOC
  * by issuing MUR and shutdown notification
  *
- * Return: 0 always.
+ * Return: 0 on success, non-zero on failure
  */
 static int __maybe_unused
 mpi3mr_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
+	int rc;
 
-	if (!shost)
-		return 0;
+	rc = mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc);
+	if (rc)
+		return rc;
 
 	mrioc = shost_priv(shost);
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
@@ -5402,13 +5433,14 @@ static int __maybe_unused
 mpi3mr_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
 	pci_power_t device_state = pdev->current_state;
 	int r;
 
-	if (!shost)
-		return 0;
+	r = mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc);
+	if (r)
+		return r;
 
 	mrioc = shost_priv(shost);
 
-- 
2.31.1


--000000000000d53335060c7e940b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIF12UP572Nm7uXa+qUJKJ37ekMBV2us9
0uzwRrQUYW0IMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMTIx
NDIxMDEwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDImH03UfWgF5P+8Z4H+ZFm+MalxhdPfs33LvlAG+emTuRCJlQR
jiMjzdy0TFYa7s6AWXq6CURpqWu1pK75XM3mJQfrIk24ugaZNAzV2UH13Awq8T1GsznvvBE94Aas
tnU4HZNVaafLpAUymm49kmNKfcuMnVw6YjabzqO47F9AnKBloZzcXRI84eygp4UxYkbXGIMki8K7
Za/pipN8ZKOj6Q6mxRdKOnv0/adK8vd4fzswbrmgjcNSxNW6B2mv8NHgsyD2BWpl1Pwa1QXVTeHQ
WeeRiRpy5kjJFhXASvY+4XNbss2z7j7R7zMjCgfNB4FZ4IRcy+lpDJS8ViMF+v/2
--000000000000d53335060c7e940b--
