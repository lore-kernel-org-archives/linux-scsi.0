Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="h/9owFSq"
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872C9D48
	for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 07:44:43 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-5c21e185df5so696431a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2023 07:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1700754283; x=1701359083; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UITn7X42djpBRTUzmuGiTq9yfGpCM2mcc9WifM1A4Ak=;
        b=h/9owFSqtBFsukDyTV688ONqlFc0D3FoK2J/RxNnf6A9NLE21Yx+4bfL38x94YkVcu
         zl46PolXaje35qhKU0VjnjdfA8PBBUFVOPEo3Njdz49TMuJxJ+KDW7pzPh3qtFBc8euj
         t8jUpf25TnCNHbKlkZGHKNSoziVrZ/+CAbdQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700754283; x=1701359083;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UITn7X42djpBRTUzmuGiTq9yfGpCM2mcc9WifM1A4Ak=;
        b=Amxc/OAGEL4j158BJ/ymIpW0KN4osk+5Jfm4J2r8WhAU2d5Givw0XTz9x/m5yNPcnO
         +WBmXPW7dM5LDAj9E48zL8uqhgYQXEO/g0+2Bv6ZbjRPL0VBabh6f2D0tCn63L3yJP8E
         /JF9QGHuU19LcuMYYWeSb5G5mUOH+S6EbIBeltxl3Ks9tc9ttpvNM6Mx9RIA76rzT2/f
         DxgfNflz3v9/30UINVRqYmZaiDKwtcBnwgo5AHIQhZHXc3r0pVm28E51kySwBTh/K4/J
         xhWxr2on+SwPmuwNhohsAtpS1QDSywlLb3lWkg5rr0GPh81ERVz6ZiboG53CA2YDy3AN
         9FYw==
X-Gm-Message-State: AOJu0Yz8qHU89jx4HjFALLSXaIytF7XJHv6xUFVHU4OVqIpJs1cBqytp
	ttmhXi8h5rsL7WqWsdrABRrr6w==
X-Google-Smtp-Source: AGHT+IGUmLL92rB1gJ+5YeyEIi0YvmV5eB/8ZonmJZqn3yI6RgyJNcEAlcGBF/w4WlLKkTR7eAwKEQ==
X-Received: by 2002:a17:90b:4a04:b0:281:40b:5a7a with SMTP id kk4-20020a17090b4a0400b00281040b5a7amr6926116pjb.8.1700754282951;
        Thu, 23 Nov 2023 07:44:42 -0800 (PST)
Received: from dhcp-10-123-20-95.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090a390d00b0028558e3f507sm1882347pjb.12.2023.11.23.07.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 07:44:42 -0800 (PST)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@broadcom.com
Cc: linux-scsi@vger.kernel.org,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	ranjan.kumar@broadcom.com,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 3/5] mpi3mr: Increase maximum number of PHYs to 64 from 32
Date: Thu, 23 Nov 2023 21:26:02 +0530
Message-Id: <20231123155604.1615-4-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20231123155604.1615-1-sumit.saxena@broadcom.com>
References: <20231123155604.1615-1-sumit.saxena@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000e8482c060ad3b697"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

--000000000000e8482c060ad3b697

SAS5116 controllers supports maximum 48 physical PHYs.
Driver is modified to accommodate up to 64 PHYs(though
current need is to support 48 PHYs).

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index ae98d15c30b1..7658e8aaadbe 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -506,7 +506,7 @@ struct mpi3mr_sas_port {
 	u8 num_phys;
 	u8 marked_responding;
 	int lowest_phy;
-	u32 phy_mask;
+	u64 phy_mask;
 	struct mpi3mr_hba_port *hba_port;
 	struct sas_identify remote_identify;
 	struct sas_rphy *rphy;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 82b55e955730..c0c8ab586957 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1587,7 +1587,7 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
  */
 struct host_port {
 	u64	sas_address;
-	u32	phy_mask;
+	u64	phy_mask;
 	u16	handle;
 	u8	iounit_port_id;
 	u8	used;
@@ -1611,7 +1611,7 @@ mpi3mr_update_mr_sas_port(struct mpi3mr_ioc *mrioc, struct host_port *h_port,
 	struct mpi3mr_sas_port *mr_sas_port)
 {
 	struct mpi3mr_sas_phy *mr_sas_phy;
-	u32 phy_mask_xor;
+	u64 phy_mask_xor;
 	u64 phys_to_be_added, phys_to_be_removed;
 	int i;
 
@@ -1619,7 +1619,7 @@ mpi3mr_update_mr_sas_port(struct mpi3mr_ioc *mrioc, struct host_port *h_port,
 	mr_sas_port->marked_responding = 1;
 
 	dev_info(&mr_sas_port->port->dev,
-	    "sas_address(0x%016llx), old: port_id %d phy_mask 0x%x, new: port_id %d phy_mask:0x%x\n",
+	    "sas_address(0x%016llx), old: port_id %d phy_mask 0x%llx, new: port_id %d phy_mask:0x%llx\n",
 	    mr_sas_port->remote_identify.sas_address,
 	    mr_sas_port->hba_port->port_id, mr_sas_port->phy_mask,
 	    h_port->iounit_port_id, h_port->phy_mask);
@@ -1637,7 +1637,7 @@ mpi3mr_update_mr_sas_port(struct mpi3mr_ioc *mrioc, struct host_port *h_port,
 	 * if these phys are previously registered with another port
 	 * then delete these phys from that port first.
 	 */
-	for_each_set_bit(i, (ulong *) &phys_to_be_added, BITS_PER_TYPE(u32)) {
+	for_each_set_bit(i, (ulong *) &phys_to_be_added, BITS_PER_TYPE(u64)) {
 		mr_sas_phy = &mrioc->sas_hba.phy[i];
 		if (mr_sas_phy->phy_belongs_to_port)
 			mpi3mr_del_phy_from_an_existing_port(mrioc,
@@ -1649,7 +1649,7 @@ mpi3mr_update_mr_sas_port(struct mpi3mr_ioc *mrioc, struct host_port *h_port,
 	}
 
 	/* Delete the phys which are not part of current mr_sas_port's port. */
-	for_each_set_bit(i, (ulong *) &phys_to_be_removed, BITS_PER_TYPE(u32)) {
+	for_each_set_bit(i, (ulong *) &phys_to_be_removed, BITS_PER_TYPE(u64)) {
 		mr_sas_phy = &mrioc->sas_hba.phy[i];
 		if (mr_sas_phy->phy_belongs_to_port)
 			mpi3mr_del_phy_from_an_existing_port(mrioc,
@@ -1671,7 +1671,7 @@ mpi3mr_update_mr_sas_port(struct mpi3mr_ioc *mrioc, struct host_port *h_port,
 void
 mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 {
-	struct host_port h_port[32];
+	struct host_port h_port[64];
 	int i, j, found, host_port_count = 0, port_idx;
 	u16 sz, attached_handle, ioc_status;
 	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
@@ -1742,7 +1742,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
 		    port_list) {
 			ioc_info(mrioc,
-			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%x), lowest phy id:%d\n",
+			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%llx), lowest phy id:%d\n",
 			    mr_sas_port->hba_port->port_id,
 			    mr_sas_port->remote_identify.sas_address,
 			    mr_sas_port->phy_mask, mr_sas_port->lowest_phy);
@@ -1751,7 +1751,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 		ioc_info(mrioc, "Host port details after reset\n");
 		for (i = 0; i < host_port_count; i++) {
 			ioc_info(mrioc,
-			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%x), lowest phy id:%d\n",
+			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%llx), lowest phy id:%d\n",
 			    h_port[i].iounit_port_id, h_port[i].sas_address,
 			    h_port[i].phy_mask, h_port[i].lowest_phy);
 		}
-- 
2.18.1


--000000000000e8482c060ad3b697
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
1J8x62/iEVbCstJaE1Nt3oXnL5yBlqX1Ihp8cZLe1weS7Wp/v5Jg2Ks13jeYOKW45xXExpqPPd1f
3meFjTf9K+rGZHb63htWaJtf0NYbE+5yIbXFv21cBxECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUTIFIrhFDaoMEbXuV9O+Y+XgS
kVwwDQYJKoZIhvcNAQELBQADggEBAFyioHqB2PHWcQ5cU8nprPRk37uSWK2x0w7W50jjc0cooz6G
G6pltJ+DvbG7XIzCU8cKHmuyAxoe1+/vhB8yJH78MVdfKDDND7zL/IqfhZedxHcHG5jVqbVH/ufu
H19y4fHxo5bLkybX3UxkN9b3bMsBZ4FFCLSCFgFfjI0BmTx6IoGyi0R89rzD0H1rURy7WTn0ijl1
nERsqENeyGfUTJLcDSURb49qpFqqWweJ7ifC64Iak8wCK2CxCe8lHfTyEgC9MuEa586NMQJDguvw
jlC7kxrgwf4sZ/9Wj/GS2HLzZPkxWCcQIrgNJm2wceHQwPBpM0ZoqL1D2tsFgOA8BvYxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwdgevXLIdo6fbCNI8w
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHpPP1CNeJfxXJAywOpfhuEQlNGuhuQh
dCtbAFUm/YvpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMTEy
MzE1NDQ0M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBMzkVbTVGy0rSk3iTm0WqHDLqD931W0zdUc3fnSFu9SDE1cEwP
vyzAMM0tMbXrmLovQVgRTkUYcHUYvDN+hOnN3XzzW0pj0CqkGMq/hSzH/Ydn0hU8+UEpApSYdgka
T2q9H8HfmOYmXzDqHlPfq6MLWtsty/w1wv9hvJs4aiR7TstaZJ2ue7QEBBOrOzNlXjx8HhxJ0cmS
kwwmVXHSTu2YFeO4lbPr3L+svFw6v+ZlZGwbvdhsYwhh0Xz6sjJzgFYg2zDY0TQH3PPdApX4rxMZ
L8OQ8zbCuROk8rp/gSj+DdEnEjzKbmYiO5iPxGuBXULfZqX7GJvBl2yv2aJQG7PM
--000000000000e8482c060ad3b697--
