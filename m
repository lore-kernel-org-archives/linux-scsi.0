Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7FDC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C032861221
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhDSLnf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 07:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbhDSLnf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 07:43:35 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FEFC06174A
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:43:05 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id d6so7483994qtx.13
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=C8UEYYP5OCUY0Q1KBB73kqP9D0Xew4WBhCIPzAICHfI=;
        b=a/2G4tkmyd+wW7+13ub0qbMYIoTWnhhixpR48EuU1F9Vk7fBdNnRB2sf6ddvZOGP04
         OM9urVTwu1GRoAaiUNbUTrMFO+YgO09JO2vpENnBeQyz7fl79Esfg3uMVT0QqRmnsxmV
         lDzUTw4CetxC6wzaNUug+EfjsO8JXu4NL5AQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=C8UEYYP5OCUY0Q1KBB73kqP9D0Xew4WBhCIPzAICHfI=;
        b=ncKoVAJQV+0KrpRKdiPiU21janwBkW5ODhe9hzs+p+8XzUB4eGMzV55SIuyCOzBisT
         APUXEvpPqBhraffQA3/qS8EaJ6WA0mx6jFY/7UE505Kke99R26/k6iWwfHB0j36Iqo+1
         buiiNvcXee5bjYW3WC89hqJMUhsTkzDcOywOKHAKvPlI56W/s7SKeJSaYEhu/N9JKGV/
         KYe0Mz8VXoCrN36EZxDjcx30e7bzdZsJe2vfhBJm2MiadZGyTC7a26Cf3lIU3xZ2sWRS
         aHpofGf4Qm4vfn13ZyVy+kM4yav+WnZ4ygoYEtlzlN6xyPl21wyThCsp4NR34tqMNHL8
         OxYw==
X-Gm-Message-State: AOAM532Bma7an1BT0NDcq8H3x9cL/E4NYdBs44AxDokok3n8nWld/+qH
        dEogl6FjXvBa7nUS5InsK/EPmabO+K+1DR/aWemulA==
X-Google-Smtp-Source: ABdhPJzXpvi5wibraqs75yA/TBNixXCHO+oVhuDHYC9qWh/b2Wgh9sbiUJg7Kw9LRHe4qs4mJcJjBbqqy4lGrRSD8f8=
X-Received: by 2002:a05:622a:3c8:: with SMTP id k8mr11418317qtx.101.1618832584404;
 Mon, 19 Apr 2021 04:43:04 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <0dda71da-4119-2e40-b8e9-ab2b3ee8e96a@huawei.com>
In-Reply-To: <0dda71da-4119-2e40-b8e9-ab2b3ee8e96a@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJLbsjCl5KLwsbVPBXkLLulR0kL0qnTQ4gw
Date:   Mon, 19 Apr 2021 17:13:01 +0530
Message-ID: <f934ca65fa55345c360c944dd0fc2239@mail.gmail.com>
Subject: RE: [bug report] scsi host hang when running fio
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
Cc:     chenxiang <chenxiang66@hisilicon.com>, luojiaxing@huawei.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002b2a8e05c051d595"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002b2a8e05c051d595
Content-Type: text/plain; charset="UTF-8"

> Hi guys,
>
> While investigating the performance issue reported by Ming [0], I am
> seeing
> this hang in certain scenarios:
>
> tivated0KB /s] [0/0/0 iops] [eta 1158048815d:13h:31m:49s] [ 740.499917]
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:ops] [eta
> 34722d:05h:17m:25s] [ 740.505994] rcu: Tasks blocked on level-1 rcu_node
> (CPUs 0-15):
> [ 740.511982] (detected by 64, t=5255 jiffies, g=6105, q=6697) [
> 740.517703]
> rcu: All QSes seen, last rcu_preempt kthread activity 0 (4295075897-
> 4295075897), jiffies_till_next_fqs=1, root ->qsmask 0x1 [ 740.723625] BUG:
> scheduling while atomic: swapper/64/0/0x00000008 [ 740.729692] Modules
> linked in:
> [ 740.732737] CPU: 64 PID: 0 Comm: swapper/64 Tainted: G W 5.12.0-rc7-
> g7589ed97c1da-dirty #322 [ 740.742432] Hardware name: Huawei TaiShan
> 2280 V2/BC82AMDC, BIOS
> 2280-V2 CS V5.B133.01 03/25/2021
> [ 740.751264] Call trace:
> [ 740.753699] dump_backtrace+0x0/0x1b0
> [ 740.757353] show_stack+0x18/0x68
> [ 740.760654] dump_stack+0xd8/0x134
> [ 740.764046] __schedule_bug+0x60/0x78
> [ 740.767694] __schedule+0x620/0x6d8
> [ 740.771168] schedule_idle+0x20/0x40
> [ 740.774730] do_idle+0x19c/0x278
> [ 740.777945] cpu_startup_entry+0x24/0x68 [ 740.781850]
> secondary_start_kernel+0x178/0x188
> [ 740.786362] 0x0
> ^Cbs: 12 (f=12): [r(12)] [0.0% done] [1626MB/0KB/0KB /s] [416K/0/0 iops]
> [eta
> 34722d:05h:16m:28s]
> fio: terminating on signal 2
>
> I thought it merited a separate thread.
>
> [ 740.723625] BUG: scheduling while atomic: swapper/64/0/0x00000008
> Looks bad ...
>
> The scenario to create seems to be running fio with rw=randread and mq-
> deadline IO scheduler. And heavily loading the system - running fio on a
> subset of available CPUs seems to help (recreate).
>
> When it occurs, the system becomes totally unresponsive.
>
> It could be a LLDD bug, but I am doubtful.
>
> Has anyone else seen this or help try to recreate?

John - I have not seen such issue on megaraid_sas driver. Is this something
to do with CPU lock up ?
Can you try your test with "rq_affinity=2" ? megaraid_sas driver detect CPU
lockup (flood of completion on single CPU) and it use irq_poll interface to
avoid such loop.
Since you mentioned you noticed issue with hisi_sas v2 without hostwide tag
I can think of similar stuffs in this case.

How cpus to irq affinity settled in your case. ? Is it 1-1 mapping ?

Kashyap

>
> scsi debug or null_blk don't seem to load the system heavily enough to
> recreate.
>
> I have seen it on 5.11 also. I see it on hisi_sas v2 and v3 hw drivers,
> And I don't
> think it's related to hostwide tags, as for hisi_sas v2 hw driver, I unset
> that flag
> and can still see it.
>
> Thanks,
> John
>
> [0]
> https://lore.kernel.org/linux-scsi/89ebc37c-21d6-c57e-4267-
> cac49a3e5953@huawei.com/T/#t

--0000000000002b2a8e05c051d595
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIILknjHaE34fvKXTYKNrCuYu1E7O
KRxr3KnW/BpwpZHyMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxOTExNDMwNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQC1hvj+SO1b2Jm3WyfeolDGEB9OsWvgg/OcjUKSiL94lwxG
rAW6U/d5QonoKsZeO0wUbEw+JuiHCY0cGDgE2ReKARHi+3uge82czT9rBq14PMrQ11zaRMfog0kv
AaCpkmF2w8Ov8lY+Uf98QP6bz21qswjpTlGWWs8JAa4/m1VaZXTuY2fIiDj9xGgY3VTlQvZMN279
TZttqgm6T51ue7BooqEL92qOIpDVes7uK+RNFk6Ggeq/fHEkDkv0yypgABkndngqFhlmHBz2AmtG
+etHhY9+CnnsXQleJM8YO0ob+yA+ZdNbLzzVnxynigAwTYrFb/lBNJpA18KL31Fq7nxd
--0000000000002b2a8e05c051d595--
