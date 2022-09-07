Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8910ECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 07:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiIGHY4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Sep 2022 03:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiIGHYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2022 03:24:38 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ED1A3D74
        for <linux-scsi@vger.kernel.org>; Wed,  7 Sep 2022 00:23:54 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y127so13763026pfy.5
        for <linux-scsi@vger.kernel.org>; Wed, 07 Sep 2022 00:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date;
        bh=fefgK+AEI6WqKT2niZstFpkrSKdeIN3J+XWt98CpnhE=;
        b=ApWYvW54C8GU2cVGAAG4sXRRaCprNFbZKF4M0ZiNtrjLVf//zSVwO8Jk+DBkTW+/57
         u/G1t3ocbVCX1Y+H7pCFsGgVJBXO2w8BYOWcUwpOwt++DU3z2GJOd3X32c4qdpdqiTZc
         jkf+gaqtDtwaHRlvma3uR/x8bZGm5AThcQAYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date;
        bh=fefgK+AEI6WqKT2niZstFpkrSKdeIN3J+XWt98CpnhE=;
        b=WXrUZjdd5EPzNZI377U64+9ajwrvJK1ZMP8CTWAv3dUhsBELjIuJlPmxSMR6Xy9gNt
         CSUEz/F/2YQst1wDLOGubtEO/FORXVQbqJ5QQz3xCJDd5bLb0LMmOiFb0ms8XUYPdBnu
         yBzzOw83EfT/b3e15bML0pgr11v3OItiynEFgLtdcZ/okHofgI+9IAOUVOr3vaFm45ti
         lVZktQ++wTblEX9SI08sZeyowJug61Jq3geSIeVb7g7DhCW7pB6Q296Hl9M8k7EtmU+I
         ogLdAtDgkwO56iJf5Iz3FxgSOpxSjml5Wl70Cifzd49Ev+oasLN0XAAqindmBQpmMW2n
         pNRQ==
X-Gm-Message-State: ACgBeo2S04YBZ2r9JFFQMKEgfIcXZf6K+4bQ503u0HNoW6PbG1arcabs
        6/FD2OyI70IFbl4wBc48Mt76KBQ55Rbo4IuqLmCXypTd9PAEtP2/hpp0RAPbUqH/dSQO98OX8/k
        z/u0so8nrAhnuWhvkK9VS9Caml7GiqdsIHX3F7+ILQ1MbF7S86vDdj9FF8mdZpF2FdNqa8cAYQT
        lUTgRZWP2s
X-Google-Smtp-Source: AA6agR6mmF0WrQZBvpS0LXRZrFuYowqJLDgAQ2iX9nIQXygOj4e6jmasqzhDdjwa9pxSOV4RgN4CMA==
X-Received: by 2002:a63:ed15:0:b0:430:48ac:3771 with SMTP id d21-20020a63ed15000000b0043048ac3771mr2160256pgi.423.1662535433569;
        Wed, 07 Sep 2022 00:23:53 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id v1-20020a1709029a0100b00176c891c893sm3907771plp.131.2022.09.07.00.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 00:23:52 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, thenzl@redhat.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 0/1] mpt3sas: Fix use-after-free warning
Date:   Wed,  7 Sep 2022 13:06:07 +0530
Message-Id: <20220907073608.12811-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000fa2b1305e81131bb"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000fa2b1305e81131bb
Content-Transfer-Encoding: 8bit

Fix below use-after-free warning which is observed during
controller reset.
 
[ 1765.313756] ------------[ cut here ]------------
[ 1765.313759] refcount_t: underflow; use-after-free.
[ 1765.313774] WARNING: CPU: 23 PID: 5399 at lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0
[ 1765.313783] Modules linked in: mpt3sas(OE) joydev uinput snd_seq_dummy snd_hrtimer nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set rfkill nf_tables nfnetlink qrtr vfat fat snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer iTCO_wdt iTCO_vendor_support snd soundcore ses enclosure intel_rapl_msr intel_rapl_common lpc_ich i2c_i801 virtio_balloon i2c_smbus pcspkr xfs libcrc32c sd_mod t10_pi qxl drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec ahci sr_mod libahci cdrom crct10dif_pclmul sg crc32_pclmul crc32c_intel raid_class libata drm ghash_clmulni_intel serio_raw e1000 scsi_transport_sas virtio_console virtio_blk virtio_scsi dm_mirror dm_region_hash dm_log dm_mod ipmi_devintf ipmi_msghandler fuse
[ 1765.313851]  [last unloaded: mpt3sas]
[ 1765.313854] CPU: 23 PID: 5399 Comm: sg_reset Kdump: loaded Tainted: G           OE    --------- ---  5.14.0-70.13.1.rt21.83.el9_0.x86_64 #1
[ 1765.313858] Hardware name: Red Hat KVM/RHEL-AV, BIOS 0.0.0 02/06/2015
[ 1765.313860] RIP: 0010:refcount_warn_saturate+0xa6/0xf0
[ 1765.313863] Code: 05 fd 59 ac 01 01 e8 82 83 53 00 0f 0b c3 80 3d eb 59 ac 01 00 75 95 48 c7 c7 b0 02 38 96 c6 05 db 59 ac 01 01 e8 63 83 53 00 <0f> 0b c3 80 3d ca 59 ac 01 00 0f 85 72 ff ff ff 48 c7 c7 08 03 38
[ 1765.313866] RSP: 0018:ffffa5aa4238fd78 EFLAGS: 00010286
[ 1765.313868] RAX: 0000000000000000 RBX: ffff91c9037fe9a0 RCX: 0000000000000000
[ 1765.313870] RDX: 0000000000000000 RSI: ffffffff9636e23c RDI: 00000000ffffffff
[ 1765.313872] RBP: ffff91c9099b2200 R08: ffffffff96a72740 R09: ffffa5aa4238fd10
[ 1765.313873] R10: 0000000000000001 R11: ffffffffffffffff R12: ffff91c9037fec40
[ 1765.313875] R13: 00000000ffffffff R14: ffff91c9037fec60 R15: ffff91c9099b22b8
[ 1765.313879] FS:  00007fd16c624600(0000) GS:ffff91d05fdc0000(0000) knlGS:0000000000000000
[ 1765.313884] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1765.313886] CR2: 00007fd16c5d78ab CR3: 0000000106228000 CR4: 0000000000350ee0
[ 1765.313887] Call Trace:
[ 1765.313911]  _scsih_fw_event_cleanup_queue+0x1ce/0x200 [mpt3sas]
[ 1765.313936]  mpt3sas_scsih_clear_outstanding_scsi_tm_commands+0xd1/0x140 [mpt3sas]
[ 1765.313955]  mpt3sas_base_hard_reset_handler+0x17f/0x260 [mpt3sas]
[ 1765.313973]  _scsih_host_reset+0x88/0xca [mpt3sas]
[ 1765.313996]  scsi_try_host_reset+0x3a/0xd0
[ 1765.314003]  scsi_ioctl_reset+0x22b/0x290
[ 1765.314006]  scsi_ioctl+0x18/0x60
[ 1765.314011]  blkdev_ioctl+0x13e/0x280
[ 1765.314017]  __x64_sys_ioctl+0x82/0xb0
[ 1765.314021]  do_syscall_64+0x3b/0x90
[ 1765.314026]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1765.314031] RIP: 0033:0x7fd16c45cc0b
[ 1765.314034] Code: 73 01 c3 48 8b 0d 1d 62 1b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed 61 1b 00 f7 d8 64 89 01 48
[ 1765.314051] RSP: 002b:00007ffeffd46b48 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 1765.314053] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fd16c45cc0b
[ 1765.314055] RDX: 00007ffeffd46b74 RSI: 0000000000002284 RDI: 0000000000000003
[ 1765.314056] RBP: 0000000000000003 R08: 0000000000000001 R09: 0000000000000000
[ 1765.314057] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffeffd46b74
[ 1765.314059] R13: 00007ffeffd48618 R14: 0000557f24af890d R15: 0000557f24afa020
[ 1765.314062] ---[ end trace 0000000000000002 ]---

Sreekanth Reddy (1):
  mpt3sas: Fix use-after-free warning

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.27.0


--000000000000fa2b1305e81131bb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHB3bTvMjTT68Y8ek++Q
XE2nycVoHjh6doTHoMNxUrsnMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDkwNzA3MjM1NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAy+wlw9igylpHS5lCsoSyQrC4YhEsh4SBk8Y7C
qe4Vzp47vQNA66LMnMzjD7OTLYnZkkr4AaV6CnOtFyRYQ7jbzT4Y43tPELmJEjtdKT0pm/XfyhvV
mbzowBHy6+EUYjPvlugDyeJCNyIyp78ZMTW8R3iGYbijtnIPj/PSoXDtTjFvTnudx93lnL9Lgzq4
p4a6vZ851FqmsBq9fT7Lr0urUI7Rn0pdJstbY7SYyi05U+t/2R1qfXa3yZSa+VDsrDa9qqlbzapw
fH1kucvObnUEKZANILEllLnmnmWPS6/K5FrzcTGwH4kHLIgGxODxG6qBRwBTtCEr7Ng8NB18KxUr
--000000000000fa2b1305e81131bb--
