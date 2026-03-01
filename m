Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1942E1C63;
	Sun,  1 Mar 2026 04:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772339165; cv=none; b=PID9qKZ8HI5AFe4rPYeSM+7xkrGm5urt+AgxexuFVQY0LXT7ame7lJv0RD10+zvxYVOug939JD5wHA2Omg7ppjhHfXcqSZUq3HgnA6WY3SIXJqq9gn+bCn6Ne9PBNnA2Qrk1h1P60+9RrtNGVWuvCE+1LTFUwATJHqNMn2gMHdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772339165; c=relaxed/simple;
	bh=ORPAoWHTglpoZriBWWOORuQlxLQLsRRTm/Lhms1ph4k=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=ffUhwLOkNoUwZdAkOZRiS5EDBCb2MQwNGaHyLGfzRc7bMj/aM3lZ9XVpstVo9/p897kqMDolzjG1ERi2SM7PruXCdFOAHdQbBtiGjIm6OI0wxirdQF2RclAyBH/U9tBxhhm8c9F0/9EYJys7N8XsvdhzLXqywyS5zqX/2PQq+nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=BabTICU+; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="BabTICU+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1772339161;
	bh=ORPAoWHTglpoZriBWWOORuQlxLQLsRRTm/Lhms1ph4k=;
	h=Message-ID:Subject:From:To:Date:From;
	b=BabTICU+a7N1i0Vl4KSsX5WU0RmzrTQT3fDCjiagFDA9H90LNa+SU4BQ3YuuQGWZv
	 +plxUQ4P4ZYAnqEfyGYtV4aauN1QtdRb+macIz+o0D53tMZQWoNKSen59BPHEdZC+A
	 lUm+Y4Sux6xCjGrWcM7DNdwxWkZdNkMaGCO14rmM=
Received: from [IPv6:2601:5c4:4300:d341::a774] (unknown [IPv6:2601:5c4:4300:d341::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 09F7D1C01DD;
	Sat, 28 Feb 2026 23:26:01 -0500 (EST)
Message-ID: <2cfc91dd26b621f5b3ba2968f326086c61fe4bf4.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.0-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 28 Feb 2026 23:26:00 -0500
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNElecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHURfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvdHRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBIFCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy09J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLbK0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDA
	QIeAQIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJpdmQTBQktxlDCAAoJEIFK5HwhSFTWUDYH/0VLi3FXXzg2duSRFBjEv2T+GojyX8UfFDejhGo52YHshpVbUE2loQg3ETn6LJq4UxmMZJYymRbe9BA3kSPS6NtFfnf90ssWgRMf7WYPMj98DOu5UlZpV2WMhvUfKI/gNfkeVW3dR7JNBZTQZv/1nNVFi/AWqf7ToEik8VcoyVuf+8Dlqyfer2xUM8QPV9XcZsu+PRSOdl8z3SH8+M9whspR1qqX7fABGSaOkZr/D3mDS8cr1ATdLbSxu8CMBMfMHbhOKoepTeXgQL/PnmZukrrFlnshJIWa7UVVrYB3qLVaujn8aP+yQqSHE7XXYku0+OWcpMa7fdjGwHKfPJnMeiO0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmVyc2hpcC5jb20+iQFXBBMBCABBAhsDBQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBQFCS3GUMIACgkQgUrkfCFIVNbpRAf8DEpytkSbT9Nm8Aifzm3j5TlrRUFZc0V1/U4VmB/lju2lU9ns8o/j1I0ZJ7uYjbZWK3pSRxb6IqZrOZGaERnLjjuJlzGvnk93+qaYGxiI2CMNNepgEBReBRxRnY5vznjmqNjbOWWgYdbb5WyypX/Yn3uVCQ0x00DQLByXEeCLDvK8Cqc+//krDSI44N/YQ0RMcAtVpHLSCXZbJ2igj9rqsJ7W0lcM8FCqyKhxPde9td0sQrKV8FbhzekHQfXpvOwS5KnKNGWE2opnYOh/vlX6z5uMm3AvIcWSib00Y3xgoc4PTOnCVFR2VieWqhtjadFKipYenA+KQ/St6c/F5ymo/LhSBFpntuYTCCqGSM49AwEHAgMEfgawiAvTJCKPlLkhINmaVHuoNA9xZT
	ExXHrNU+wCghN2MoWNoOZQBORL6XnOaIKtQFwnowFq8+JhDiSqfj/HBokBswQYAQgAJgIbAhYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJpdmSfBQkh2rC5AIF2IAQZEwgAHRYhBOdgQNt2yj0XZwj5qudCyUzumKyFBQJaZ7bmAAoJEOdCyUzumKyF2L0BAPI68tg4GTKUGqJOUmsycYIKxaAZnA+kqrd7ezslD/EEAQCXHb2k9jnPREvIgNSyN/2a2RI1Np5pDpMiMOsVr7xcfwkQgUrkfCFIVNbHmQgAk3WhtOC5ajSffgDF25vqZreQJPJS0HCRnHxvfLe2WnJvShmaexY6BFyYtLmamrBRYcefLZSZkgc8nWOdlA7kr94Hj8GMrX5hZQHi6zzN0g3v9B+YTUh1btDbIcuPQWKjKUhD9EGrH0XNhB8nRIeSfwb3mDHyQ1tcd2lso5GUaYPHIgO8VKkNAJHyurxuyTYJjQi2T0i656zCK8I9NBh7gs58BTbHMqBRI5Q4oDLgzXg6o5CUUmZhS7ON2Xb7J+twT6GXG+iRjE+uMa72fiZax5l0upKcYYkOS2q2lSVwgwsGBftya4CPWzMwmCI3NYPFO2XdAOVP9ouvFQSSK1Sm6LhWBFpntyUSCCqGSM49AwEHAgMEx+4y4T48QJs6hiOQPRN6ejtMNtyDEk2A9XtjaVBs0Gd7Ews4Rjr/EnNGLVeb+j2Y7Jn5UiPyHgblX95ZKe02TAMBCAeJATwEGAEIACYCGwwWIQTVYG5zyLRicb6tmt+BSuR8IUhU1gUCaXZkMwUJIdqwDgAKCRCBSuR8IUhU1pfLB/wLszTzsV2JYbCYLOdPF0dGcv+dSx8rLiydrJ/hgv4fcTJgXv45zzNCL/QqHAiKjnxXeSRsFBjyHf3gYXmhbP5eGCW81eZHOUDy7CoSyZRPzIPf1At8IFia3pPZ+xibcIz7JntKFWWw43YdtVghoGZIxa5PM4v
	ESQBwmRFUv0DF2TFKWHM7amrZAal162kknsH5gKQnFRdX1uLZHw51BzeW+Mzso3xcGi2iby9hcACv1L5TZTQpyD67B+znqj884Vgj4JKdInPQgxJ1yS7aR0ezRHqJYJrjHmzR4aSRFIEnw5azZlH/lsvKCee42fPGoZ956VcVZCagf29mjzDLXxGmuQINBFR2FpkBEACl4X2Bs1IEG51bzF4xAiIH8JnArhU4Q/ucYdmfdSxZ6ay8T2W+NsXNupwiRtSnZXoTEzm3ISDOKjYFq8t7VkkYdVoqQvdwosAGhiL/IEsSeiA8XPNh8rZ92KmbYb4aEtqp8PG0BDtypd6jVMKxktK+MP6QtVXVO8qVodLy1QKHahTJHt9Nu/pYeLkfwMvJHQ+du30T38ZyzWPXUlf4xYnuOx63YVUOwHlTUszvQCOFeIOJAK00nMpqop0x6LzNrNZLnSIwop6jib9p1YGMb/yV3d9Dv8dyPo6mSHzE9oKeaANmi9gZq/DgCba2NGoTobqs9ClLTB7kjqVKwo0E//YWEuYj1+ewGdkLWXU2sBJFJfUErTF/gtgHZbDd9hCZtsCkBQFtZn/VpChzYQIptIr2JbSB9nysOCB8zDyfOmYQQTGXSFTrC0kvKbINX5Aag/HkrBgr/qoBQ0lAidRjPzPYREz8c4jT1m7eOJq4UEO2i5Iitpf/YMO9N/st97X6KEBEVKWnriQQwCyMq600Era7miPgfuFDvMP4G9YsfEyDKw61hi3CCDB46sz+TdGd2xn/PeewaoXSCBy3VUu4fZ7OcOSwj4qRncGDRaKFDIntn2iaBpADJEMVy36Ocmy/YjNr7Ei896L5+lsY0DIW+PR75OxmhAZwLfj+KkbDN7rnVQARAQABiQEfBCgBAgAJBQJVPoFoAh0DAAoJEIFK5HwhSFTWnlAIALumCM4zXsfHCrP2aUYQuKViqPM09Shm3nGyVxMUbGP9BY3O7QryARA94+dzl1N+
	6bNYvTvufGF0pi2irCbYLp86ZeIkFnHqSEF9Gpy1S83YOU4Hp0V/kj7VBP1NEG9x4bPDTUTgaLTGNYoAHo4ggwB2c9wNUXNpcl2UAAl2N+D+XIm0DLGJ9+Ubw2dcnd6XAaqgGyjzhcE1ZbNtzlUqZq3OFgs69e1/MOG7iY0+//PtLUdO1GC4jQ2UflFUHNK9/PJuKf2HKwTf/6vcLQcnbGI4fO5w0CYbTdrO3NlgMxNspBbhtCp4PkwnFPry8Fi7wy3N8h7jWVIulv+qXCrWqDSJASUEGAECAA8FAlR2FpkCGwwFCQDtTgAACgkQgUrkfCFIVNbdiAf8DIkvauUK8auQtxqz3g0P0+afRxSVWs+XvBUZwhX7ojievDq7j1PKo0yaxhqbZimN6u8kaBu8hszOgcUJESLpH1fJSzDnDsYJGhZ6DDZuVliLkDnbF7nTT79Gu4b/8wp861VSi27c367sVxdpgCD2Bth4Y1kJXvS8j5ycWCrQAQlF2OJ3N8JZUo+Np9OjuMd4XFftDbaRR9Y6QzPOGgNsWDSM+FVg2IRek3JcLCKvO8oDtu8XBk+VGRt+KFqJcMTtAohS1DXSLmTDgL2uoMrDHwXQ9pYNEX2AZop3v8gkYclppz85xInfrPGCQ2AuxVfkZSugnYZplxHtb1WmmPkf4LhSBGS5HJMTCCqGSM49AwEHAgME7JKiaexbZKQCle/XNQFoPfx0USPQtB4MQx1ITtubV+et2MBi3R/8K1tRSINo+h1CTap4fM4/rAD/YrquuPA0hYkBPQQYAQgAJwMbIAQWIQTVYG5zyLRicb6tmt+BSuR8IUhU1gUCaXZkiAUJF4lK9QAKCRCBSuR8IUhU1t6CCACFp/Wk55zQu2MQAvzXSexcBczROJSLUiNL8hRejgidulGRb/nvvxgsPQkdKxvxi02LFcU2jeFK5TuuRvebZozJ0LDJsECWJ0CHUoWzN+FZ/j0IG4qPgGSD1DIdfwGft
	AHBLpBdnl9SOe8ETkv6GqbZrXUED/dAbRVIT5vHP51zyYB8rAUjp3PnzxsXFG8eQaacEyKSl0DKDlgKuQ+k292LVGJhEva8z4cwg3JcrQWzbpTRskQRP624aQ7t0LKbNfXqfYT13TvZNTDdjQaCJRJ3EG8uXOszVKuc0guXunZPmmq6x1Y3bOfOezcFYoywwL3nKef+Z5sQrjG3/5NLeu+W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

All changes in drivers (well technically ses is enclosure services, but
its change is minor).  The biggest is the write combining change in
lpfc followed by the additional NULL checks in mpi3mr.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alexey Charkov (1):
      scsi: ufs: core: Fix RPMB region size detection for UFS 2.2

Jan Kiszka (1):
      scsi: storvsc: Fix scheduling while atomic on PREEMPT_RT

Karan Tilak Kumar (1):
      scsi: snic: MAINTAINERS: Update snic maintainers

Mathias Krause (1):
      scsi: lpfc: Properly set WC for DPP mapping

Peter Wang (2):
      scsi: ufs: core: Move link recovery for hibern8 exit failure to wl_re=
sume
      scsi: ufs: core: Fix possible NULL pointer dereference in ufshcd_add_=
command_trace()

Ranjan Kumar (1):
      scsi: mpi3mr: Add NULL checks when resetting request and reply queues

Salomon Dushimirimana (1):
      scsi: pm8001: Fix use-after-free in pm8001_queue_command()

Thomas Fourier (1):
      scsi: snic: Remove unused linkstatus

Tomas Henzl (1):
      scsi: ses: Fix devices attaching to different hosts

Won Jung (1):
      scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime PM power mod=
e

wangshuaiwei (1):
      scsi: ufs: core: Fix shift out of bounds when MAXQ=3D32

And the diffstat:

 MAINTAINERS                      |  1 +
 drivers/scsi/lpfc/lpfc_init.c    |  2 ++
 drivers/scsi/lpfc/lpfc_sli.c     | 36 +++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_sli4.h    |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 34 ++++++++++++++++-------------
 drivers/scsi/pm8001/pm8001_sas.c |  5 +++--
 drivers/scsi/ses.c               |  5 ++---
 drivers/scsi/snic/vnic_dev.c     |  9 --------
 drivers/scsi/storvsc_drv.c       |  5 +++--
 drivers/ufs/core/ufshcd.c        | 47 +++++++++++++++++++++++++++++-------=
----
 10 files changed, 97 insertions(+), 50 deletions(-)

With full diff below.

Regards,

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 55af015174a5..f1e4d0799611 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6213,6 +6213,7 @@ F:	drivers/scsi/fnic/
=20
 CISCO SCSI HBA DRIVER
 M:	Karan Tilak Kumar <kartilak@cisco.com>
+M:	Narsimhulu Musini <nmusini@cisco.com>
 M:	Sesidhar Baddela <sebaddel@cisco.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 94ad253d65a0..e9d9ac7da485 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12025,6 +12025,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
 		iounmap(phba->sli4_hba.conf_regs_memmap_p);
 		if (phba->sli4_hba.dpp_regs_memmap_p)
 			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
+		if (phba->sli4_hba.dpp_regs_memmap_wc_p)
+			iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1cbfbe44cb7c..303523f754b8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15977,6 +15977,32 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba,=
 uint16_t pci_barset)
 	return NULL;
 }
=20
+static __maybe_unused void __iomem *
+lpfc_dpp_wc_map(struct lpfc_hba *phba, uint8_t dpp_barset)
+{
+
+	/* DPP region is supposed to cover 64-bit BAR2 */
+	if (dpp_barset !=3D WQ_PCI_BAR_4_AND_5) {
+		lpfc_log_msg(phba, KERN_WARNING, LOG_INIT,
+			     "3273 dpp_barset x%x !=3D WQ_PCI_BAR_4_AND_5\n",
+			     dpp_barset);
+		return NULL;
+	}
+
+	if (!phba->sli4_hba.dpp_regs_memmap_wc_p) {
+		void __iomem *dpp_map;
+
+		dpp_map =3D ioremap_wc(phba->pci_bar2_map,
+				     pci_resource_len(phba->pcidev,
+						      PCI_64BIT_BAR4));
+
+		if (dpp_map)
+			phba->sli4_hba.dpp_regs_memmap_wc_p =3D dpp_map;
+	}
+
+	return phba->sli4_hba.dpp_regs_memmap_wc_p;
+}
+
 /**
  * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on EQs
  * @phba: HBA structure that EQs are on.
@@ -16940,9 +16966,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_q=
ueue *wq,
 	uint8_t dpp_barset;
 	uint32_t dpp_offset;
 	uint8_t wq_create_version;
-#ifdef CONFIG_X86
-	unsigned long pg_addr;
-#endif
=20
 	/* sanity check on queue memory */
 	if (!wq || !cq)
@@ -17128,14 +17151,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc=
_queue *wq,
=20
 #ifdef CONFIG_X86
 			/* Enable combined writes for DPP aperture */
-			pg_addr =3D (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
-			rc =3D set_memory_wc(pg_addr, 1);
-			if (rc) {
+			bar_memmap_p =3D lpfc_dpp_wc_map(phba, dpp_barset);
+			if (!bar_memmap_p) {
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"3272 Cannot setup Combined "
 					"Write on WQ[%d] - disable DPP\n",
 					wq->queue_id);
 				phba->cfg_enable_dpp =3D 0;
+			} else {
+				wq->dpp_regaddr =3D bar_memmap_p + dpp_offset;
 			}
 #else
 			phba->cfg_enable_dpp =3D 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index ee58383492b2..b6d90604bb61 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -785,6 +785,9 @@ struct lpfc_sli4_hba {
 	void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped address for
 					   * dpp registers
 					   */
+	void __iomem *dpp_regs_memmap_wc_p;/* Kernel memory mapped address for
+					    * dpp registers with write combining
+					    */
 	union {
 		struct {
 			/* IF Type 0, BAR 0 PCI cfg space reg mem map */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_f=
w.c
index 81150bef1145..5875065e2849 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4807,21 +4807,25 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc=
)
 	}
=20
 	for (i =3D 0; i < mrioc->num_queues; i++) {
-		mrioc->op_reply_qinfo[i].qid =3D 0;
-		mrioc->op_reply_qinfo[i].ci =3D 0;
-		mrioc->op_reply_qinfo[i].num_replies =3D 0;
-		mrioc->op_reply_qinfo[i].ephase =3D 0;
-		atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
-		atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
-		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
-
-		mrioc->req_qinfo[i].ci =3D 0;
-		mrioc->req_qinfo[i].pi =3D 0;
-		mrioc->req_qinfo[i].num_requests =3D 0;
-		mrioc->req_qinfo[i].qid =3D 0;
-		mrioc->req_qinfo[i].reply_qid =3D 0;
-		spin_lock_init(&mrioc->req_qinfo[i].q_lock);
-		mpi3mr_memset_op_req_q_buffers(mrioc, i);
+		if (mrioc->op_reply_qinfo) {
+			mrioc->op_reply_qinfo[i].qid =3D 0;
+			mrioc->op_reply_qinfo[i].ci =3D 0;
+			mrioc->op_reply_qinfo[i].num_replies =3D 0;
+			mrioc->op_reply_qinfo[i].ephase =3D 0;
+			atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
+			atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
+			mpi3mr_memset_op_reply_q_buffers(mrioc, i);
+		}
+
+		if (mrioc->req_qinfo) {
+			mrioc->req_qinfo[i].ci =3D 0;
+			mrioc->req_qinfo[i].pi =3D 0;
+			mrioc->req_qinfo[i].num_requests =3D 0;
+			mrioc->req_qinfo[i].qid =3D 0;
+			mrioc->req_qinfo[i].reply_qid =3D 0;
+			spin_lock_init(&mrioc->req_qinfo[i].q_lock);
+			mpi3mr_memset_op_req_q_buffers(mrioc, i);
+		}
 	}
=20
 	atomic_set(&mrioc->pend_large_data_sz, 0);
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_=
sas.c
index 6a8d35aea93a..645524f3fe2d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -525,8 +525,9 @@ int pm8001_queue_command(struct sas_task *task, gfp_t g=
fp_flags)
 		} else {
 			task->task_done(task);
 		}
-		rc =3D -ENODEV;
-		goto err_out;
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec device gone\n");
+		return 0;
 	}
=20
 	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 35101e9b7ba7..8e1686358e25 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -528,9 +528,8 @@ struct efd {
 };
=20
 static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
-				      void *data)
+				      struct efd *efd)
 {
-	struct efd *efd =3D data;
 	int i;
 	struct ses_component *scomp;
=20
@@ -683,7 +682,7 @@ static void ses_match_to_enclosure(struct enclosure_dev=
ice *edev,
 	if (efd.addr) {
 		efd.dev =3D &sdev->sdev_gendev;
=20
-		enclosure_for_each_device(ses_enclosure_find_by_addr, &efd);
+		ses_enclosure_find_by_addr(edev, &efd);
 	}
 }
=20
diff --git a/drivers/scsi/snic/vnic_dev.c b/drivers/scsi/snic/vnic_dev.c
index c692de061f29..ed7771e62854 100644
--- a/drivers/scsi/snic/vnic_dev.c
+++ b/drivers/scsi/snic/vnic_dev.c
@@ -42,8 +42,6 @@ struct vnic_dev {
 	struct vnic_devcmd_notify *notify;
 	struct vnic_devcmd_notify notify_copy;
 	dma_addr_t notify_pa;
-	u32 *linkstatus;
-	dma_addr_t linkstatus_pa;
 	struct vnic_stats *stats;
 	dma_addr_t stats_pa;
 	struct vnic_devcmd_fw_info *fw_info;
@@ -650,8 +648,6 @@ int svnic_dev_init(struct vnic_dev *vdev, int arg)
=20
 int svnic_dev_link_status(struct vnic_dev *vdev)
 {
-	if (vdev->linkstatus)
-		return *vdev->linkstatus;
=20
 	if (!vnic_dev_notify_ready(vdev))
 		return 0;
@@ -686,11 +682,6 @@ void svnic_dev_unregister(struct vnic_dev *vdev)
 				sizeof(struct vnic_devcmd_notify),
 				vdev->notify,
 				vdev->notify_pa);
-		if (vdev->linkstatus)
-			dma_free_coherent(&vdev->pdev->dev,
-				sizeof(u32),
-				vdev->linkstatus,
-				vdev->linkstatus_pa);
 		if (vdev->stats)
 			dma_free_coherent(&vdev->pdev->dev,
 				sizeof(struct vnic_stats),
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 664ad55728b5..ae1abab97835 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1856,8 +1856,9 @@ static enum scsi_qc_status storvsc_queuecommand(struc=
t Scsi_Host *host,
 	cmd_request->payload_sz =3D payload_sz;
=20
 	/* Invokes the vsc to start an IO */
-	ret =3D storvsc_do_io(dev, cmd_request, get_cpu());
-	put_cpu();
+	migrate_disable();
+	ret =3D storvsc_do_io(dev, cmd_request, smp_processor_id());
+	migrate_enable();
=20
 	if (ret)
 		scsi_dma_unmap(scmnd);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 847b55789bb8..899e663fea6e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -24,6 +24,7 @@
 #include <linux/pm_opp.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched/clock.h>
+#include <linux/sizes.h>
 #include <linux/iopoll.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
@@ -517,8 +518,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hb=
a, struct scsi_cmnd *cmd,
=20
 	if (hba->mcq_enabled) {
 		struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
-
-		hwq_id =3D hwq->id;
+		if (hwq)
+			hwq_id =3D hwq->id;
 	} else {
 		doorbell =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	}
@@ -4389,14 +4390,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, =
struct uic_command *cmd)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
=20
-	/*
-	 * If the h8 exit fails during the runtime resume process, it becomes
-	 * stuck and cannot be recovered through the error handler.  To fix
-	 * this, use link recovery instead of the error handler.
-	 */
-	if (ret && hba->pm_op_in_progress)
-		ret =3D ufshcd_link_recovery(hba);
-
 	return ret;
 }
=20
@@ -5249,6 +5242,25 @@ static void ufshcd_lu_init(struct ufs_hba *hba, stru=
ct scsi_device *sdev)
 		hba->dev_info.rpmb_region_size[1] =3D desc_buf[RPMB_UNIT_DESC_PARAM_REGI=
ON1_SIZE];
 		hba->dev_info.rpmb_region_size[2] =3D desc_buf[RPMB_UNIT_DESC_PARAM_REGI=
ON2_SIZE];
 		hba->dev_info.rpmb_region_size[3] =3D desc_buf[RPMB_UNIT_DESC_PARAM_REGI=
ON3_SIZE];
+
+		if (hba->dev_info.wspecversion <=3D 0x0220) {
+			/*
+			 * These older spec chips have only one RPMB region,
+			 * sized between 128 kB minimum and 16 MB maximum.
+			 * No per region size fields are provided (respective
+			 * REGIONX_SIZE fields always contain zeros), so get
+			 * it from the logical block count and size fields for
+			 * compatibility
+			 *
+			 * (See JESD220C-2_2 Section 14.1.4.6
+			 * RPMB Unit Descriptor,* offset 13h, 4 bytes)
+			 */
+			hba->dev_info.rpmb_region_size[0] =3D
+				(get_unaligned_be64(desc_buf
+					+ RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_COUNT)
+				<< desc_buf[RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_SIZE])
+				/ SZ_128K;
+		}
 	}
=20
=20
@@ -5963,6 +5975,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *=
hba)
=20
 	hba->auto_bkops_enabled =3D false;
 	trace_ufshcd_auto_bkops_state(hba, "Disabled");
+	hba->urgent_bkops_lvl =3D BKOPS_STATUS_PERF_IMPACT;
 	hba->is_urgent_bkops_lvl_checked =3D false;
 out:
 	return err;
@@ -6066,7 +6079,7 @@ static void ufshcd_bkops_exception_event_handler(stru=
ct ufs_hba *hba)
 	 * impacted or critical. Handle these device by determining their urgent
 	 * bkops status at runtime.
 	 */
-	if (curr_status < BKOPS_STATUS_PERF_IMPACT) {
+	if ((curr_status > BKOPS_STATUS_NO_OP) && (curr_status < BKOPS_STATUS_PER=
F_IMPACT)) {
 		dev_err(hba->dev, "%s: device raised urgent BKOPS exception for bkops st=
atus %d\n",
 				__func__, curr_status);
 		/* update the current status as the urgent bkops level */
@@ -7097,7 +7110,7 @@ static irqreturn_t ufshcd_handle_mcq_cq_events(struct=
 ufs_hba *hba)
=20
 	ret =3D ufshcd_vops_get_outstanding_cqs(hba, &outstanding_cqs);
 	if (ret)
-		outstanding_cqs =3D (1U << hba->nr_hw_queues) - 1;
+		outstanding_cqs =3D (1ULL << hba->nr_hw_queues) - 1;
=20
 	/* Exclude the poll queues */
 	nr_queues =3D hba->nr_hw_queues - hba->nr_queues[HCTX_TYPE_POLL];
@@ -10179,7 +10192,15 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba,=
 enum ufs_pm_op pm_op)
 		} else {
 			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
 					__func__, ret);
-			goto vendor_suspend;
+			/*
+			 * If the h8 exit fails during the runtime resume
+			 * process, it becomes stuck and cannot be recovered
+			 * through the error handler. To fix this, use link
+			 * recovery instead of the error handler.
+			 */
+			ret =3D ufshcd_link_recovery(hba);
+			if (ret)
+				goto vendor_suspend;
 		}
 	} else if (ufshcd_is_link_off(hba)) {
 		/*

