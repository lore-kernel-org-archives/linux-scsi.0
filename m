Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE04C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 06:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbiCVGfn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 02:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbiCVGfn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 02:35:43 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C2B1121
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 23:34:15 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-de3f2a19c8so894619fac.1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 23:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KyUpRI09ieyRGb7Vklk/2au1SWX675PE94H01WnMIEw=;
        b=GXrqwP/76Z+MyHSRfowekF8RQ3cfOzXBZhl+9r9MHexlCfJMEwN93m9ykWI7jfA9hR
         2lfGJx8PD5RIQRsHYuc6CMxXQyLDZ8f4x/wPu9N+EVqkbUJn9DlEnPoRkFuGBx0duvWR
         2ycAmOOhtHTOmXoW0xIOkX0OyzO1jcVdfxbVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KyUpRI09ieyRGb7Vklk/2au1SWX675PE94H01WnMIEw=;
        b=jyv5BndoU/GQeuxKxZQlGH3nG6snHNN3uXL3/MrYD+jTf+9gh8m09Qn9Kz8oNElTZD
         D41HV5207LL7tIPrBIHp5su9QXINAdEBdwpQxbulCWx9h9G57U1OMtmDsTHv6kMmUPxR
         afMARotvCZSI7J8D3dnZiRLE2RHgRroAJBeRY9UP/50GpVtgfYUYSB5sTlfKHj/CU3Ih
         0QcQ3rXgmjR7UPIt1Tb1P+57+aOi9/OpBR4wuc9hdgSA10kk8E+eG0bs3VMafmeB1XJI
         SM3KehP5NfSEpjmC+oYm7QlXw1j+Za5lKwXqnjhFvkOpdUq4+xvMdxVUzTDymMufLOsg
         mi4A==
X-Gm-Message-State: AOAM5328Fk6j+2qBN4NIVcjwLLwnlP8IBy5WFfT5fLKaE2EITq9lt8Zx
        /3+d+PIZxi5QD3YplEgMu9S4b2qDACB7x5bt47/81WZiWv8WKlsE
X-Google-Smtp-Source: ABdhPJz0cMXkYS0S6bany3XiUSe9n3UtItC0nRPd+uOPnLG1fDvNavNxb5KswKcWpHd4c1PXDkB/1VfLUYzxSlWPIbQ=
X-Received: by 2002:a05:6870:c1d3:b0:dd:af96:4db7 with SMTP id
 i19-20020a056870c1d300b000ddaf964db7mr1007656oad.204.1647930854640; Mon, 21
 Mar 2022 23:34:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220322055702.95276-1-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220322055702.95276-1-damien.lemoal@opensource.wdc.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Tue, 22 Mar 2022 12:04:03 +0530
Message-ID: <CAK=zhgq_u3=ZZpjNOcfGk_8+p_GzodfN_c9yTxV68o0Fi9sqiA@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: mpt3sas: fix use after free in _scsih_expander_node_remove()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003a474605dac8cd33"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003a474605dac8cd33
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 22, 2022 at 11:28 AM 'Damien Le Moal' via
PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com> wrote:
>
> The function mpt3sas_transport_port_remove() called in
> _scsih_expander_node_remove() frees the port field of the sas_expander
> structure, leading to the following use-after-free splat from Kasan when
> the ioc_info() call following that function is executed (e.g. when doing
> rmmod of the driver module):
>
> [ 3479.371167] ==================================================================
> [ 3479.378496] BUG: KASAN: use-after-free in _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.386936] Read of size 1 at addr ffff8881c037691c by task rmmod/1531
> [ 3479.393524]
> [ 3479.395035] CPU: 18 PID: 1531 Comm: rmmod Not tainted 5.17.0-rc8+ #1436
> [ 3479.401712] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.1 06/02/2021
> [ 3479.409263] Call Trace:
> [ 3479.411743]  <TASK>
> [ 3479.413875]  dump_stack_lvl+0x45/0x59
> [ 3479.417582]  print_address_description.constprop.0+0x1f/0x120
> [ 3479.423389]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.429469]  kasan_report.cold+0x83/0xdf
> [ 3479.433438]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.439514]  _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.445411]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
> [ 3479.452032]  scsih_remove+0x525/0xc90 [mpt3sas]
> [ 3479.458212]  ? mpt3sas_expander_remove+0x1d0/0x1d0 [mpt3sas]
> [ 3479.465529]  ? down_write+0xde/0x150
> [ 3479.470746]  ? up_write+0x14d/0x460
> [ 3479.475840]  ? kernfs_find_ns+0x137/0x310
> [ 3479.481438]  pci_device_remove+0x65/0x110
> [ 3479.487013]  __device_release_driver+0x316/0x680
> [ 3479.493180]  driver_detach+0x1ec/0x2d0
> [ 3479.498499]  bus_remove_driver+0xe7/0x2d0
> [ 3479.504081]  pci_unregister_driver+0x26/0x250
> [ 3479.510033]  _mpt3sas_exit+0x2b/0x6cf [mpt3sas]
> [ 3479.516144]  __x64_sys_delete_module+0x2fd/0x510
> [ 3479.522315]  ? free_module+0xaa0/0xaa0
> [ 3479.527593]  ? __cond_resched+0x1c/0x90
> [ 3479.532951]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
> [ 3479.539607]  ? syscall_enter_from_user_mode+0x21/0x70
> [ 3479.546161]  ? trace_hardirqs_on+0x1c/0x110
> [ 3479.551828]  do_syscall_64+0x35/0x80
> [ 3479.556884]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 3479.563402] RIP: 0033:0x7f1fc482483b
> ...
> [ 3479.943087] ==================================================================
>
> Fix this by introducing the local variable port_id to store the port ID
> value before executing mpt3sas_transport_port_remove(). This local
> variable is then used in the call to ioc_info() instead of dereferencing
> the freed port structure.
>
> Fixes: 7d310f241001 ("scsi: mpt3sas: Get device objects using sas_address & portID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Thanks for the patch.
Ack-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

> ---
> Changes from v1:
> * Use local variable to store the port ID instead of reversing the calls
>   to ioc_info() and mpt3sas_transport_port_remove().
>
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 00792767c620..7e476f50935b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -11035,6 +11035,7 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
>  {
>         struct _sas_port *mpt3sas_port, *next;
>         unsigned long flags;
> +       int port_id;
>
>         /* remove sibling ports attached to this expander */
>         list_for_each_entry_safe(mpt3sas_port, next,
> @@ -11055,6 +11056,8 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
>                             mpt3sas_port->hba_port);
>         }
>
> +       port_id = sas_expander->port->port_id;
> +
>         mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
>             sas_expander->sas_address_parent, sas_expander->port);
>
> @@ -11062,7 +11065,7 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
>             "expander_remove: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
>             sas_expander->handle, (unsigned long long)
>             sas_expander->sas_address,
> -           sas_expander->port->port_id);
> +           port_id);
>
>         spin_lock_irqsave(&ioc->sas_node_lock, flags);
>         list_del(&sas_expander->list);
> --
> 2.35.1
>

--0000000000003a474605dac8cd33
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDpFF/3gWOVdKiP4UryR
nUhQmbOBeSJmAaSq/AFGuh4aMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDMyMjA2MzQxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB3iwu3izEhaHMM/Y6A5Z7tJq3FiuONDszN3QIT
U0/c9cw7sq9CR+WqqKIMIbbY/cvkOkBhK+qQMTfMsDowBEIm0SY9ZqbvucTNasdKEhriZU7W27kI
ozDTuu13695aBR8QJBvbijkYcC3zjtq1x/hmLa1ITOUx5ychFZPdh5F2aaTHwHqrlHgdhuSH5Z3u
L8JJS4YM5YEDS/ikGyVWvbpvICOhGskHCVfT9nX0czN3EG/ZF1EuHpv9FWyIjOEQ99k8Hcp8ATXa
timS5KJQ9EYQg1o8iCGSnSZLUz1927qVdciw1n8kfz5hQM6Yhl16CgqvqATsM2nvovFAiM57S/Oy
--0000000000003a474605dac8cd33--
