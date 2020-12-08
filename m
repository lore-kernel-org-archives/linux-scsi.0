Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD39C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 05:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65AF423A5E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 05:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgLHFBI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 00:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgLHFBH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 00:01:07 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3704DC0613D6
        for <linux-scsi@vger.kernel.org>; Mon,  7 Dec 2020 21:00:27 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id s75so15107446oih.1
        for <linux-scsi@vger.kernel.org>; Mon, 07 Dec 2020 21:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=zzqxn0TSzfM6sRDGXhwOU1ANBzLH51jepX/Cx7sDhU0=;
        b=I8XX8EaYI0BSYgbMiYNyeDY4xuylx4O6zKXd66PwdOsmnRvGX028l7C9RMm1H6Jc/T
         aQ6zU9DW3yeq+ZcM/yoQk2VsvxWwr2AYXR+JPJomKD5Guk1JcjVE5f/xfY8uuZEovw+l
         DV2QYrxTR0C+1pJj8RiGF20CsenSzL1fR+rBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=zzqxn0TSzfM6sRDGXhwOU1ANBzLH51jepX/Cx7sDhU0=;
        b=RR/SWHESzTYH62btFGrMIzKd+RQVqC6Gcq/Dd28VJL1Arn3/HD7sV2H5rmHQk38Aei
         iC/ZkMDhPA2DWXG+rR1C1mYHe8FezqzVgKKB9gZ/LHG0gRxxW4BkhDB/FXJtKPgo3l7U
         rsp9AUeELJkRYlmNa6DLyLgp5I7L7h/WT0nzYWQ3l1sJVcb2QR5sOph5p56l9g0qEGbT
         IBv46wgE9HqcDhSd7VtbFoAPMIfZcdILiIDh/dhie3QKsOhhjLdGrBY1dRZu8fGwhNmm
         DtIqFw98mBzDlzHVQbmz9U5tzWxHb7twtIwZBFTzBd3Bkq7vDvmufpoyzinLrlQpMtZw
         70Rw==
X-Gm-Message-State: AOAM531P2z7aNwkKDFKH7qBBF2wPDEOMLcQ30l0HJ+lnHWODNMfkbn2S
        23VSfn0kahQbyrJHi9VjVQq+zJIkEl0QBQH5JPYxiAjr21h6XQ6I9PCowPokxF8FGr3VSzDIMpl
        T/FBKCiEv04dJWAnUY+N4iGNOaI8ZNpzQeS9/
X-Google-Smtp-Source: ABdhPJwdwul38yQ3Dkl9uZZHY24WcAcrhnnNq9j+s8FK+JedNrQrPGiHarkelqMlP+IvAowU+YTqFVik7p/6d+DWwu0=
X-Received: by 2002:aca:5413:: with SMTP id i19mr1535807oib.87.1607403626109;
 Mon, 07 Dec 2020 21:00:26 -0800 (PST)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
In-Reply-To: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIH8uuDM4YiJUHm/GbjmPgWle4NwamKUUZA
Date:   Tue, 8 Dec 2020 10:30:21 +0530
Message-ID: <962c402e28d9183caef263f9fac215b3@mail.gmail.com>
Subject: RE: [PATCH v7 0/5] scsi: Support to handle Intermittent errors
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Hannes Reinecke <hare@suse.de>
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000029db8d05b5ecd2ed"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000029db8d05b5ecd2ed
Content-Type: text/plain; charset="UTF-8"

Hi Martin,
Could you please let us know if the patch series can get committed to the
scsi tree .
This patch series has been reviewed by Hannes,Ewan and Himanshu.


Thanks,
Muneendra.

-----Original Message-----
From: Muneendra [mailto:muneendra.kumar@broadcom.com]
Sent: Wednesday, November 11, 2020 10:28 AM
To: linux-scsi@vger.kernel.org; michael.christie@oracle.com; hare@suse.de
Cc: jsmart2021@gmail.com; emilne@redhat.com; mkumar@redhat.com; Muneendra
<muneendra.kumar@broadcom.com>
Subject: [PATCH v7 0/5] scsi: Support to handle Intermittent errors

This patch adds a support to prevent retries of all the io's after an
abort succeeds on a particular device when transport connectivity to the
device is encountering intermittent errors.

Intermittent connectivity is a condition that can be detected by transport
fabric notifications. A service can monitor the ELS notifications and take
action on all the outstanding io's of a scsi device at that instant.

This feature is intended to be used when the device is part of a multipath
environment. When the service detects the poor connectivity, the multipath
path can be placed in a marginal path group and ignored further io
operations.

After placing a path in the marginal path group,the daemon sets the
port_state to Marginal which sets bit in scmd->state for all the io's on
that particular device with the new sysfs interface provided in this
patch.This prevent retries of all the io's if an io hits a scsi timeout
which inturn issues an abort.
On Abort succeeds on a marginal path the io will be immediately retried on
another active path.On abort fails then the things escalates to existing
target reset sg interface recovery process.

Below is the interface provided to set the port state to Marginal and
Online.
echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state


The patches were cut against  5.11/scsi-queue tree

---
v7:

Added New routine in scsi_host_template to decide if a cmd is retryable
instead of checking the same using  SCMD_NORETRIES_ABORT bit as the cmd
retry part can be checked by validating the port state.

Removed the changes related to SCMD_NORETRIES_ABORT bit.

Added a new function fc_eh_should_retry_cmd to check whether the cmd
should be retried based on the rport state.

Reoreder the patch

The patches were cut against  5.11/scsi-queue tree


v6:
Reordered the patches to make patch ordering and more logical.

v5:
Added the DID_TRANSPORT_MARGINAL case to scsi_decide_disposition

Made changes to clear the SCMD_NORETRIES_ABORT bit if the port_state has
changed from marginal to online due to port_delete and port_add as we need
the normal cmd retry behaviour while we are calling the eh handlers.

Made changes in fc_scsi_scan_rport as we are checking FC_PORTSTATE_ONLINE
instead of FC_PORTSTATE_ONLINE and FC_PORTSTATE_MARGINAL


v4:
Made changes in fc_eh_timed_out callout to set the SCMD_NORETRIES_ABORT if
port state is marginal

With this change, we  removed the code  to loop over running commands and
fc_remote_port_chkready changes to set the SCMD_NORETRIES_ABORT

Removed the scsi_cmd argument for fc_remote_port_chkready and reverted
back the patches that addressed this change(argument)

Removed unnecessary comments
Handle the return of errors on failure.

v3:
Removed the port_state from starget attributes.
Enabled the store functionality for port_state under remote port Added a
new argument to scsi_cmd  to fc_remote_port_chkready Used the existing
scsi command iterators scsi_host_busy_iter.
Rearranged the patches
Added new patches to add new argument for fc_remote_port_chkready

v2:
Added new error code DID_TRANSPORT_MARGINAL to handle marginal errors.
Added a new rport_state FC_PORTSTATE_MARGINAL and also added a new sysfs
interface port_state to set the port_state to marginal.
Added the support in lpfc to handle the marginal state.


*** BLURB HERE ***

Muneendra (5):
  scsi: Added a new error code DID_TRANSPORT_MARGINAL in scsi.h
  scsi: No retries on abort success
  scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
  scsi_transport_fc: Added store fucntionality to set the rport
    port_state using sysfs
  scsi:lpfc: Added support for eh_should_retry_cmd

 drivers/scsi/lpfc/lpfc_scsi.c    |   1 +
 drivers/scsi/scsi_error.c        |  23 +++++-
 drivers/scsi/scsi_lib.c          |   1 +
 drivers/scsi/scsi_transport_fc.c | 118 ++++++++++++++++++++++++++-----
 include/scsi/scsi.h              |   1 +
 include/scsi/scsi_host.h         |   6 ++
 include/scsi/scsi_transport_fc.h |   4 +-
 7 files changed, 133 insertions(+), 21 deletions(-)

--
2.26.2

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--00000000000029db8d05b5ecd2ed
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
J/4V6ms/nIUi+/4vPYjckYUbRzkXm1/X0IyUfpp5cgdrFn9jBIk69fQGAUEhnVvwcXnHWotYxZFd
Xew5Fz0CAwEAAaOCAdMwggHPMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYI
KwYBBQUHMAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxz
aWduMnNoYTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5j
b20vZ3NwZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAA
MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNp
Z24yc2hhMmczLmNybDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMG
A1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFGlygmIxZ5VEhXeRgMQENkmdewthMB0GA1Ud
DgQWBBR6On9cEmlB2VsuST951zNMSKtFBzANBgkqhkiG9w0BAQsFAAOCAQEAOGDBLQ17Ge8BVULh
hsKhgh5eDx0mNmRRdhvTJnxOTRX5QsOKvsJGOUbyrKjD3BTTcGmIUti9HmbqDe/3gRTbhu8LA508
LbMkW5lUoTb8ycBNOKLYhNE8UEOY8jRTUtMEhzT6NJDEE+1hb3kSGfArrrF3Z8pRYiUUhcpC5GKL
9KsxA+DECRfSGfXJJQSq6nEZUGKhz+dz5CV1s8UIZLe9HEEfyJO4eRP+Fw9X16cthAbY0kpVnAvT
/j45FAauY/h87uphdvSb5wC9v5w4VO0JKs0yNUjyWXg/RG+6JCvcViLFLAlRCLrcRcVaQwWZQ3YB
EpmWnHflnrBcah5Ozy137DGCAm8wggJrAgEBMG0wXTELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEds
b2JhbFNpZ24gbnYtc2ExMzAxBgNVBAMTKkdsb2JhbFNpZ24gUGVyc29uYWxTaWduIDIgQ0EgLSBT
SEEyNTYgLSBHMwIMX/krgFDQUQNyOf+1MA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEi
BCAUIV+NKY+JxVItAmwQDhvyg+uFuTiOVtlgQZXbuV1h2jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEyMDgwNTAwMjZaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAFbsGcXKXH8kmo8gV
zivXTKVTz/viVYRuSyZ2e+Kr6bdjpXoxn0fPDTbUCoS7Ma4syXEVdc7GsLBEbelMzMtoNaZ3eUHM
P2ajwjZ1RA8qVRtE470JsgH4Ya3+LnNeddFxOacOUfOuH1DWytBfywz8hkwhFTVobjYY6trZfnjW
CXc2awzzCO/81W8zH8WD7sovEaoDoT6IzIicEK+SqB2c5Cjixu4FzUZ3hrw58hakq66CfiYFQ05y
lSUAjYiLsmG/3wQWP/CJBGL95pzkf/xCF7p8VHlTm3woZVYJ9rNHkcMX3bW4bceGVwr2TBDe4piG
BM1TENL2KnoMK+5l0NCAeQ==
--00000000000029db8d05b5ecd2ed--
