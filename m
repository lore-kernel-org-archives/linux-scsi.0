Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607A5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4901660F4A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242399AbhJGUeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242542AbhJGUeA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:34:00 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C216C061773
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 13:32:02 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id 73so7323025qki.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=Wtby4mbdKqFOECzNWKRpqNemok2fvD/KSV0nBlEJyzc=;
        b=KTmLZSYqNcWFutMofcj++PQ38bpaa290xVCqvxTof5gsWZdCcjLE/dSUVHoa2k6aY6
         czOxSaf3J1e3JR+v9ntzJJfzikzLHI9/0d6Xk2NJ6mecKzfWbZ2MFl3dTQmHrXXYR7oI
         fedkerF4x8nhfE+ANxRQ0a6EuePbtntZsjEJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=Wtby4mbdKqFOECzNWKRpqNemok2fvD/KSV0nBlEJyzc=;
        b=b/LcKbjhz3MwsFOl0+WW8nvf8Z8gvvg/qG91MRIV0Ms2wSLA3eBeW/fXHygMR3R1KU
         EXuvUbzcLKyYfwaLTfD/D2ORczkVc2gQu5UoGGuQ7m77PT6KjYGpnIzfDhJwE22ax287
         g5PJc+YQ0GUplAMwWIGgr/RjOsNovg4cB6aGE6dJO/iaspw4jqb9u5XMgbn2wEUR7uaD
         1PFLb9aobiNkMWdorcMnriBQ85eku1vOB9Jp/Rfu6vx0BYoOAUKeJkOLtgaK3ddSY2ag
         R439S/vOdX0X1aMTuD7gKXsFG+KCGkPd+xopeofdNIybI5a1q8c8WEL9GK1Myjivya/U
         hDkA==
X-Gm-Message-State: AOAM531ogDrS/j58x97lKQITgRTnGsCOHBW+jotXaQ5LPseIlJzDXUTC
        bqv4c/DCpT60pcN6g1SkIZUQLeE5Ifv/iSf6/FPnKQ==
X-Google-Smtp-Source: ABdhPJydKhChwBLCRAksv1FmDtptvtptbHz5loaUb7CZMytdLcc5fF5RXgnsOVnqWlnoeGt/nIlOYPiK+oTWYWfWA3I=
X-Received: by 2002:a37:8242:: with SMTP id e63mr5334586qkd.294.1633638721551;
 Thu, 07 Oct 2021 13:32:01 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
 <ae33dde8-96e8-2978-5f32-c7e0a6136e8e@kernel.dk> <81d9e019-b730-221e-a8c0-f72a8422a2ec@huawei.com>
 d3a11ba59cc0a912fa6486a148a7458a@mail.gmail.com
In-Reply-To: d3a11ba59cc0a912fa6486a148a7458a@mail.gmail.com
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQGgGyzjlHsoUBOKQforaoyr3oYZHgFiajqbAYnHiCCsHEhW8IADf5Xg
Date:   Fri, 8 Oct 2021 02:01:52 +0530
Message-ID: <e4e92abbe9d52bcba6b8cc6c91c442cc@mail.gmail.com>
Subject: RE: [PATCH v5 00/14] blk-mq: Reduce static requests memory footprint
 for shared sbitmap
To:     John Garry <john.garry@huawei.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, hare@suse.de, linux-scsi@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b60f8a05cdc9271b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000b60f8a05cdc9271b
Content-Type: text/plain; charset="UTF-8"

> > -----Original Message-----
> > From: John Garry [mailto:john.garry@huawei.com]
> > Sent: Tuesday, October 5, 2021 7:05 PM
> > To: Jens Axboe <axboe@kernel.dk>; kashyap.desai@broadcom.com
> > Cc: linux-block@vger.kernel.org; linux-kernel@vger.kernel.org;
> > ming.lei@redhat.com; hare@suse.de; linux-scsi@vger.kernel.org
> > Subject: Re: [PATCH v5 00/14] blk-mq: Reduce static requests memory
> > footprint for shared sbitmap
> >
> > On 05/10/2021 13:35, Jens Axboe wrote:
> > >> Baseline is 1b2d1439fc25 (block/for-next) Merge branch 'for-
> 5.16/io_uring'
> > >> into for-next
> > > Let's get this queued up for testing, thanks John.
> >
> > Cheers, appreciated
> >
> > @Kashyap, You mentioned that when testing you saw a performance
> > regression from v5.11 -> v5.12 - any idea on that yet? Can you
> > describe the scenario, like IO scheduler and how many disks and the
> > type? Does disabling host_tagset_enable restore performance?
>
> John - I am still working on this. System was not available due to some
> other
> debugging.

John -

I tested this patchset on 5.15-rc4 (master) -
https://github.com/torvalds/linux.git

#1 I noticed some performance regression @mq-deadline scheduler which is not
related to this series. I will bisect and get more detail about this issue
separately.
#2  w.r.t this patchset, I noticed one issue which is related to cpu usage
is high in certain case.

I have covered test on same setup using same h/w. I tested on Aero MegaRaid
Controller.

Test #1 : Total 24 SAS SSDs in JBOD mode.
(numactl -N 1 fio
24.fio --rw=randread --bs=4k --iodepth=256 --numjobs=1
--ioscheduler=none/mq-deadline)
No performance regression is noticed using this patchset. I can get 3.1 M
IOPs (max IOPs on this setup). I noticed some CPU hogging issue if iodepth
from application is high.

Cpu usage data from (top)
%Node1 :  6.4 us, 57.5 sy,  0.0 ni, 23.7 id,  0.0 wa,  0.0 hi, 12.4 si,  0.0
st

Perf top data -
     19.11%  [kernel]        [k] native_queued_spin_lock_slowpath
     4.72%  [megaraid_sas]  [k] complete_cmd_fusion
     3.70%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
     2.76%  [megaraid_sas]  [k] megasas_build_ldio_fusion
     2.16%  [kernel]        [k] syscall_return_via_sysret
     2.16%  [kernel]        [k] entry_SYSCALL_64
     1.87%  [megaraid_sas]  [k] megasas_queue_command
     1.58%  [kernel]        [k] io_submit_one
     1.53%  [kernel]        [k] llist_add_batch
     1.51%  [kernel]        [k] blk_mq_find_and_get_req
     1.43%  [kernel]        [k] llist_reverse_order
     1.42%  [kernel]        [k] scsi_complete
     1.18%  [kernel]        [k] blk_mq_rq_ctx_init.isra.51
     1.17%  [kernel]        [k] _raw_spin_lock_irqsave
     1.15%  [kernel]        [k] blk_mq_get_driver_tag
     1.09%  [kernel]        [k] read_tsc
     0.97%  [kernel]        [k] native_irq_return_iret
     0.91%  [kernel]        [k] scsi_queue_rq
     0.89%  [kernel]        [k] blk_complete_reqs

Perf top data indicates lock contention in "blk_mq_find_and_get_req" call.

1.31%     1.31%  kworker/57:1H-k  [kernel.vmlinux]
     native_queued_spin_lock_slowpath
     ret_from_fork
     kthread
     worker_thread
     process_one_work
     blk_mq_timeout_work
     blk_mq_queue_tag_busy_iter
     bt_iter
     blk_mq_find_and_get_req
     _raw_spin_lock_irqsave
     native_queued_spin_lock_slowpath


Kernel v5.14 Data -

%Node1 :  8.4 us, 31.2 sy,  0.0 ni, 43.7 id,  0.0 wa,  0.0 hi, 16.8 si,  0.0
st
     4.46%  [kernel]       [k] complete_cmd_fusion
     3.69%  [kernel]       [k] megasas_build_and_issue_cmd_fusion
     2.97%  [kernel]       [k] blk_mq_find_and_get_req
     2.81%  [kernel]       [k] megasas_build_ldio_fusion
     2.62%  [kernel]       [k] syscall_return_via_sysret
     2.17%  [kernel]       [k] __entry_text_start
     2.01%  [kernel]       [k] io_submit_one
     1.87%  [kernel]       [k] scsi_queue_rq
     1.77%  [kernel]       [k] native_queued_spin_lock_slowpath
     1.76%  [kernel]       [k] scsi_complete
     1.66%  [kernel]       [k] llist_reverse_order
     1.63%  [kernel]       [k] _raw_spin_lock_irqsave
     1.61%  [kernel]       [k] llist_add_batch
     1.39%  [kernel]       [k] aio_complete_rw
     1.37%  [kernel]       [k] read_tsc
     1.07%  [kernel]       [k] blk_complete_reqs
     1.07%  [kernel]       [k] native_irq_return_iret
     1.04%  [kernel]       [k] __x86_indirect_thunk_rax
     1.03%  fio            [.] __fio_gettime
     1.00%  [kernel]       [k] flush_smp_call_function_queue


Test #2: Three VDs (each VD consist of 8 SAS SSDs).
(numactl -N 1 fio
3vd.fio --rw=randread --bs=4k --iodepth=32 --numjobs=8
--ioscheduler=none/mq-deadline)

There is a performance regression but it is not due to this patch set.
Kernel v5.11 gives 2.1M IOPs on mq-deadline but 5.15 (without this patchset)
gives 1.8M IOPs.
In this test I did not noticed CPU issue as mentioned in Test-1.

In general, I noticed host_busy is incorrect once I apply this patchset. It
should not be more than can_queue, but sysfs host_busy value is very high
when IOs are running. This issue is only after applying this patchset.

Is this patch set only change the behavior of <shared_host_tag> enabled
driver ? Will there be any impact on mpi3mr driver ? I can test that as
well.

Kashyap

>
> >
> >  From checking differences between those kernels, I don't see anything
> > directly relevant in sbitmap support or in the megaraid sas driver.
> >
> > Thanks,
> > John

--000000000000b60f8a05cdc9271b
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIBLEYiJ31FcL8QmOf5+FfuSdRU1
dRNC24XDSNp5kpyJMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MTAwNzIwMzIwMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQB9jy2296MrlWT9pTkePlDfqNRDOeATMZTyhwC53xaVSuNJ
m240XWF7szUAzScJUs6By80cXF3N8G+VgkdVN90WxDHKCFPFUUUWMZnK7+WSEhHyMREzyVlw8Ugz
0vC33u776Yx6SCPeFWvvO81pZV8tU3JQ+6d46VK+0wgVSb1+qsFuPKJuNMPI32nv9zBg+mM2fe3y
jQtx8GcwEKxbSn3vOCyueEJwfHjk3aFXjeRpamnXYXP+jXM/4KHlliI/RT03GaHBJs8mR5m1fQOG
TSzlI9wTpkcqt/OKM0+q/K2AyOJh5MkNRK93NqUYZ9kdM/f90LHuwX8KV3Jv+ZRRRYsw
--000000000000b60f8a05cdc9271b--
