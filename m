Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DE0C43465
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 10:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522D02068E
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 10:41:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dRKU9hyY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgIRKlO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 06:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgIRKlN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 06:41:13 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732C7C06174A
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2020 03:41:13 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id a15so4693448ljk.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2020 03:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UbxBR/h4hVMrSTYugXgspyMRCFZIXrGu00Jz37MMnXc=;
        b=dRKU9hyYTdbIiikLw0d1pk8PhYOMXIe/pSSPGm8zxdRMFpsazS0Jvy67iCLbZKG1mK
         9Q/QjRTHgNbGjBGVaNCwkztZ6QturpuYEt9YV2nBtoU4iW30fhVI2xX9ilOgQ0xVT5kV
         Cjm5kOumLrKx6F1Td3vvbcVvsQfwUZIGxfZ1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UbxBR/h4hVMrSTYugXgspyMRCFZIXrGu00Jz37MMnXc=;
        b=YiSSxlad121LKfPOjq+5jwBRn4sP76EVet8/Me32ht2a5yAD8BR9TDYtqXiv8dNUs2
         ClWgM9ksDZ/CZI0tE9qAjv8UkojsvDIrD0W2kHJzlfxW87YA83bFCZfwryd4flOJGtZH
         lrORKafVKhl7+upjrI3pS6fSOhtxB49ef3yCYTjXHsoi8DXVv5iINOJDCQ6DEYvm8O0T
         bneDLa0u5r4KExj7d2ex54oXtQGReP1yduBOyIy1ZkpOt6+6f4BwqMisnF2/HQ2N8OJw
         W5m8TVL8MYUk4GB0KXl00Qdd0ySLnagafsgT7FAD7jSEb/bdq1XfqGvlnQ6ounT8F5Te
         k0Mw==
X-Gm-Message-State: AOAM531c8mJhlQVCVKhj/A81u5s/Cl5P2NVsOfxFzlHwXtTSxQeS2wUp
        bQ59/uRLLbUVStEgKLkPClBmnvdmm9ZuMkECPRpGfdMbBGEViA==
X-Google-Smtp-Source: ABdhPJwHW12UOHL4wdZsAZAeuto8Bjy39cDEcZ5cZIjNIlRC1cbtFf4W481+GXT2qd/ZMTtTsoFCgcczHWdgHAStrJI=
X-Received: by 2002:a2e:9410:: with SMTP id i16mr12357079ljh.443.1600425671594;
 Fri, 18 Sep 2020 03:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <a29522ab-6246-00b6-57b9-cd8d7c8766dc@domedata.com>
In-Reply-To: <a29522ab-6246-00b6-57b9-cd8d7c8766dc@domedata.com>
From:   Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Fri, 18 Sep 2020 16:15:03 +0530
Message-ID: <CA+RiK66O-0giupGduKOvTEoSmn1H21u_1ROjqZRGFy4+JX2gmA@mail.gmail.com>
Subject: Re: bug in mpt3sas vs Lenovo 530-8i
To:     Adam Schrotenboer <adam@domedata.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ac9c7a05af9423d0"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ac9c7a05af9423d0
Content-Type: text/plain; charset="UTF-8"

Hi Adam,

Provide complete driver log with driver logging_level=0x83f8. From the
log snippet, I could see the controller reset and it may be due to
ioctl timeout also?.
Complete driver log will help to have a better understanding.

Thanks,
Suganath


On Fri, Sep 18, 2020 at 11:55 AM Adam Schrotenboer <adam@domedata.com> wrote:
>
> I have two Lenovo 530-8i with the IT-mode firmware installed, this
> occurs with both despite different versions of firmware.
>
> the bootup for the currently installed card says MPT35BIOS-9.03.00.00
> (2017.02.02).
>
> The other card has been updated to the most recent off of the website, I
> believe it's 9.31.00.00.
>
> This bug occurs with either one. The machine is brand new, Ryzen 3800XT
> and an ASUS X570-Pro, and running Debian 10.5; the Lenovo 530-8i are
> used from eBay.
>
> This bug does not occur with linux-image-4.19.0-10-amd64  4.19.132-1.
>
> it does occur with linux-image-5.4.0-0.bpo.4-amd64 5.4.19-1~bpo10+1.
>
> a bisect log is below.
>
> In the good case (with the bad commit reverted, on a 5.8 kernel), this
> occurs in the dmesg log approximately every 600 seconds:
>
> [ 1804.145603] mpt3sas_cm0: log_info(0x30030109): originator(IOP),
> code(0x03), sub_code(0x0109)
> [ 1804.145621] mpt3sas_cm0: log_info(0x30030101): originator(IOP),
> code(0x03), sub_code(0x0101)
>
> In the bad case [note that the exact output varies by kernel version, I
> believe the below is the distro kernel 5.4.19]:
>
> [  664.939927] mf:
> [  664.939927]
> [  664.939928] 12000002
> [  664.939929] 00000000
> [  664.939929] 00000000
> [  664.939929] 00000000
> [  664.939930] 00000000
> [  664.939930] 000c0000
> [  664.939930] 00000000
> [  664.939931] 00010000
> [  664.939931]
> [  664.939931]
> [  664.939931] 00010000
> [  664.939932]
> [  664.939940] mpt3sas_cm0: sending diag reset !!
> [  665.697392] mpt3sas_cm0: diag reset: SUCCESS
> [  665.760406] mpt3sas_cm0: CurrentHostPageSize is 0: Setting default
> host page size to 4k
> [  665.877256] mpt3sas_cm0: _base_display_fwpkg_version: complete
> [  665.877257] mpt3sas_cm0: FW Package Version (02.00.05.02)
> [  665.877521] mpt3sas_cm0: SAS3408: FWVersion(02.00.05.00),
> ChipRevision(0x01), BiosVersion(09.03.00.00)
> [  665.877522] NVMe
> [  665.877522] mpt3sas_cm0: Protocol=(Initiator,Target),
> Capabilities=(TLR,EEDP,Diag Trace Buffer,Task Set Full,NCQ)
> [  665.877569] mpt3sas_cm0: sending port enable !!
> [  673.055652] mpt3sas_cm0: port enable: SUCCESS
> [  673.055791] mpt3sas_cm0: search for end-devices: start
> [  673.056100] scsi target6:0:1: handle(0x0009),
> sas_addr(0x510600b00cf4d920)
> [  673.056102] scsi target6:0:1: enclosure logical
> id(0x500605b00cf4d920), slot(8)
> [  673.056170] scsi target6:0:0: handle(0x000b),
> sas_addr(0x500151b0000020b3)
> [  673.056171] scsi target6:0:0: enclosure logical
> id(0x500151b0000020bf), slot(6)
> [  673.056172]  handle changed from(0x000c)!!!
> [  673.056207] scsi target6:0:2: handle(0x000c),
> sas_addr(0x500151b0000020bd)
> [  673.056208] scsi target6:0:2: enclosure logical
> id(0x500151b0000020bf), slot(0)
> [  673.056208]  handle changed from(0x000d)!!!
> [  673.056275] scsi target6:0:3: handle(0x000e),
> sas_addr(0x500151b0000000bd)
> [  673.056276] scsi target6:0:3: enclosure logical
> id(0x500151b0000000bf), slot(0)
> [  673.056315] mpt3sas_cm0: search for end-devices: complete
> [  673.056316] mpt3sas_cm0: search for end-devices: start
> [  673.056316] mpt3sas_cm0: search for PCIe end-devices: complete
> [  673.056317] mpt3sas_cm0: search for expanders: start
> [  673.056351]  expander present: handle(0x000a),
> sas_addr(0x500151b0000020bf)
> [  673.056384]  expander present: handle(0x000d),
> sas_addr(0x500151b0000000bf)
> [  673.056385]  expander(0x500151b0000000bf): handle changed
> from(0x000b) to (0x000d)!!!
> [  673.056419] mpt3sas_cm0: search for expanders: complete
> [  673.056427] mpt3sas_cm0: removing unresponding devices: start
> [  673.056428] mpt3sas_cm0: removing unresponding devices: end-devices
> [  673.056429] mpt3sas_cm0: Removing unresponding devices: pcie end-devices
> [  673.056430] mpt3sas_cm0: removing unresponding devices: expanders
> [  673.056430] mpt3sas_cm0: removing unresponding devices: complete
> [  673.056432] mpt3sas_cm0: scan devices: start
> [  673.056773] mpt3sas_cm0:     scan devices: expanders start
> [  673.058860] mpt3sas_cm0:     break from expander scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [  673.058860] mpt3sas_cm0:     scan devices: expanders complete
> [  673.058861] mpt3sas_cm0:     scan devices: end devices start
> [  673.059363] mpt3sas_cm0:     break from end device scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [  673.059363] mpt3sas_cm0:     scan devices: end devices complete
> [  673.059364] mpt3sas_cm0:     scan devices: pcie end devices start
> [  673.059394] mpt3sas_cm0:     break from pcie end device scan:
> ioc_status(0x0022), loginfo(0x310f0400)
> [  673.059395] mpt3sas_cm0:     pcie devices: pcie end devices complete
> [  673.059395] mpt3sas_cm0: scan devices: complete
>
> From the below bisect, this commit appears to be at fault:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e224e03b0c6a2381ed1ea5325c846582d87d6fae
> Note that, per https://lkml.org/lkml/2020/7/7/392 [from a static
> analysis tool coccinelle], the commit isn't necessary for mpt3sas_base.c.
>
> In my testing, only the change to mpt3sas_ctl.c is causing the issue
> (that is, reverting the commit on this file but leaving mpt3sas_base.c
> with this change makes the bug disappear).
>
> git bisect start
>
> # good: [84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d] Linux 4.19
> git bisect good 84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d
> # bad: [219d54332a09e8d8741c1e1982f5eae56099de85] Linux 5.4
> git bisect bad 219d54332a09e8d8741c1e1982f5eae56099de85
> # good: [5fb5c395e2c4658a57f894ae9ab72b3d4d71a882] nfp: flower: add qos
> offload stats request and reply
> git bisect good 5fb5c395e2c4658a57f894ae9ab72b3d4d71a882
> # good: [168869492e7009b6861b615f1d030c99bc805e83] docs: kbuild: fix
> build with pdf and fix some minor issues
> git bisect good 168869492e7009b6861b615f1d030c99bc805e83
> # good: [e444d51b14c4795074f485c79debd234931f0e49] Merge tag
> 'tty-5.4-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> git bisect good e444d51b14c4795074f485c79debd234931f0e49
> # good: [574cc4539762561d96b456dbc0544d8898bd4c6e] Merge tag
> 'drm-next-2019-09-18' of git://anongit.freedesktop.org/drm/drm
> git bisect good 574cc4539762561d96b456dbc0544d8898bd4c6e
> # bad: [298fb76a5583900a155d387efaf37a8b39e5dea2] Merge tag 'nfsd-5.4'
> of git://linux-nfs.org/~bfields/linux
> git bisect bad 298fb76a5583900a155d387efaf37a8b39e5dea2
> # bad: [5c6bd5de3c2e5bc8a17451e281ed2613375a7fd5] Merge tag 'mips_5.4'
> of git://git.kernel.org/pub/scm/linux/kernel/git/mips/linux
> git bisect bad 5c6bd5de3c2e5bc8a17451e281ed2613375a7fd5
> # good: [84da111de0b4be15bd500deff773f5116f39f7be] Merge tag
> 'for-linus-hmm' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma
> git bisect good 84da111de0b4be15bd500deff773f5116f39f7be
> # bad: [10fd71780f7d155f4e35fecfad0ebd4a725a244b] Merge tag 'scsi-misc'
> of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
> git bisect bad 10fd71780f7d155f4e35fecfad0ebd4a725a244b
> # bad: [328bc6debf3dcaf8859dd1323882e8e24ec6e3f8] scsi: hisi_sas: remove
> set but not used variable 'irq_value'
> git bisect bad 328bc6debf3dcaf8859dd1323882e8e24ec6e3f8
> # bad: [cc74049f35e84b6727c70589750c84e6166963ae] scsi: qla2xxx: Use
> strlcpy() instead of strncpy()
> git bisect bad cc74049f35e84b6727c70589750c84e6166963ae
> # good: [93352abc81a90314bf032038200ce96989a32c62] scsi: hisi_sas: Make
> max IPTT count equal for all hw revisions
> git bisect good 93352abc81a90314bf032038200ce96989a32c62
> # bad: [9c067c053f94d36006cd0a29cf02b0b6be54c6ca] scsi: mpt3sas: Handle
> fault during HBA initialization
> git bisect bad 9c067c053f94d36006cd0a29cf02b0b6be54c6ca
> # good: [a07b48766c5232b98154f68010512a9269f2841e] scsi: hisi_sas:
> Remove some unnecessary code
> git bisect good a07b48766c5232b98154f68010512a9269f2841e
> # bad: [ffedeae1fa545a1d07e6827180c3923bf67af59f] scsi: mpt3sas:
> Gracefully handle online firmware update
> git bisect bad ffedeae1fa545a1d07e6827180c3923bf67af59f
> # good: [afcd609e8e7907ccfa04fef0a3adb7d60a298ed6] scsi: pm80xx: remove
> redundant assignments to variable rc
> git bisect good afcd609e8e7907ccfa04fef0a3adb7d60a298ed6
> # bad: [e224e03b0c6a2381ed1ea5325c846582d87d6fae] scsi: mpt3sas: memset
> request frame before reusing
> git bisect bad e224e03b0c6a2381ed1ea5325c846582d87d6fae
> # good: [f23ca2cb2781102b560dbd96fe093b146fd8ec1a] scsi: mpt3sas: Add
> support for PCIe Lane margin
> git bisect good f23ca2cb2781102b560dbd96fe093b146fd8ec1a
> # first bad commit: [e224e03b0c6a2381ed1ea5325c846582d87d6fae] scsi:
> mpt3sas: memset request frame before reusing
>
> `ver_linux` as requested in reporting-bugs
>
> tabris@mercury:~/linux-kernel.git$ awk -f scripts/ver_linux
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>
> Linux mercury 5.8.10mpt3sas+ #12 SMP Thu Sep 17 11:44:53 EDT 2020 x86_64
> GNU/Linux
>
> GNU Make                4.2.1
> Binutils                2.31.1
> Util-linux              2.33.1
> Mount                   2.33.1
> Bison                   3.3.2
> Flex                    2.6.4
> Dynamic linker (ldd)    2.28
> Procps                  3.3.15
> Kbd                     2.0.4
> Console-tools           2.0.4
> Sh-utils                8.30
> Udev                    241
> Modules Loaded          acpi_cpufreq aesni_intel ahci amd64_edac_mod
> asus_wmi autofs4 battery bna button ccp cec crc16 crc32c_generic
> crc32c_intel crc32_pclmul crct10dif_pclmul cryptd crypto_simd dca drm
> drm_kms_helper edac_mce_amd eeepc_wmi efi_pstore efivarfs efivars
> enclosure evdev ext4 fat ghash_clmulni_intel glue_helper hid hid_generic
> hwmon_vid i2c_algo_bit i2c_piix4 igb ip_tables irqbypass jbd2 jc42
> joydev k10temp kvm libahci libata libcrc32c mbcache mpt3sas msr mxm_wmi
> nct6775 nls_ascii nls_cp437 pcspkr pps_core ptp radeon raid_class rapl
> rfkill rng_core scsi_mod scsi_transport_sas sd_mod ses sg snd snd_pcm
> snd_timer soundcore sp5100_tco sparse_keymap t10_pi tiny_power_button
> ttm usbcore usbhid vfat video watchdog wmi wmi_bmof xfs xhci_hcd
> xhci_pci x_tables
>

--000000000000ac9c7a05af9423d0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iUkiVw86iw1/yBRkUHjZV+F5nigRTD1p16yuvarGtyB6rg4jKzna5QV4nk8+hvH80mioAJQGVzts
8xzpVqdUE0XKNyTxbKeog4Szn+7BAgMBAAGjggHcMIIB2DAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsG
AQUFBwEBBIGRMIGOME0GCCsGAQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc3BlcnNvbmFsc2lnbjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29j
c3AyLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisG
AQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3Np
dG9yeS8wCQYDVR0TBAIwADBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24u
Y29tL2dzcGVyc29uYWxzaWduMnNoYTJnMy5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUu
c3VicmFtYW5pQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRp
coJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU/c23ZwEKsymUWmWA1y8P9Rg3/S4wDQYJKoZI
hvcNAQELBQADggEBALOKJyKtCFXYqEKp/a6z7VfKi9uLkcftrcrYXqV3K6PB8j7qnYb37eV1DCBs
+gdZLkbSE0oBBzV/dqmsngPjBwkLSigxsRg1K44sgdBpolmGw/gESFR8P2tXB0l+UEEq4kzhz6sM
bCYKYpNz68rpFqaHpBXisSwGMZwPHsfyh2Stv/1cNBG6dGpoUgZcoFjXT7Akx1Tz11FUkRjNsUAc
DAYA3uHCdaZTnVbSESs1pk+HAhlZhqrDYXWCG6ya+SIG51Q4PHS6jfst/6xnaSFPhWhIv2hSB2NA
vWzrcXMq9IfE5HFZXqzOWMP/gUOKk155U6EuRQzVcCpabG8ROpPND3sxggJvMIICawIBATBtMF0x
CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxT
aWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDE84Ya9bsUMoMZ6qKjANBglghkgB
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgt+CYBHK/gJ/PRkf1IuNxNodI0Xr2YZ9ZoUywNJZq
r1wwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwOTE4MTA0MTEy
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAABGiSAvkOmyguhlFENh4xrkv0IJYxoKd3GTN7ARqbKmTIgJZHMbKQym9MNL
7geYmzRm9QcASzKMioYvK2kNYFQslBh3kmCnKbq1HklWIYrWX+RtkHPFNQMi7jI/RrKuX5/n/nNP
Wdxemu/hChRuVCQs+oKml+kYBDpc4a9ETgm6SMNPFgFEUOnMB3hWUrID72YhUSjj9BTh+0QNQ7yZ
dsh4fsS6CFc93JShsXIhAvwfTNiwLcR/50hn8h27N0HzI8na6uvMzR5oLS7SkoESLPMC3x2qYq0A
HF1yZ7p8usxJlZZWy0JBe3ye3VmWLPmU1oo4j5pCcwhum415+At7UJ4=
--000000000000ac9c7a05af9423d0--
