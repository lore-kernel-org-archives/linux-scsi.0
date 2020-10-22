Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	MIME_NO_TEXT,SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30094C388F9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 19:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBEB12465D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 19:28:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KTZx3ygv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509603AbgJVT2V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 15:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508349AbgJVT2V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Oct 2020 15:28:21 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC04AC0613CE
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2020 12:28:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l18so1575124pgg.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2020 12:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ze22d1Ef/4NHZsfYJtkZP4FWclfRmXLyfBddSRe5gyE=;
        b=KTZx3ygvyi2tVtGIzORcUCf3BXAvpiRfvSfwhhEHQt+Wbu/OGNDTf9CM3lPjqapnbA
         MADbEhzMKntibiHCrQSCiMgaoA+FJVV3kxBN/0b9N/IUrAzTNIkGTWrWkiZVpOtXSy1Y
         +czAAjQpYnrGqKS/p1dWPnyWzjQDKYzHGJN5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ze22d1Ef/4NHZsfYJtkZP4FWclfRmXLyfBddSRe5gyE=;
        b=cjodfsEARfohX66bxBtYkBLGq8c/qgzjtRkKgentFaWW5gC+nXvTZ6XNkPa7I/8DNq
         +aU8JIRXAYGkq4RLRZz92Hee/zlbBwimJNM3e4/iVRlNBvde6g9wcm6vgMF59L0EOI5R
         8vndCezOtVKaA9ykyBDskirtUzzxcdjmBM2f5Rq9k6G44W1ZE2OKiEF4164MMxsMZALl
         a2J4WJsoqdTQrMCah03RgEsUe4FXssAar8g8ib58D9cqkbQywsMGLcR5l4kcu1FbXtPd
         UWQUaapgowDVsvTRnkJhW2hIHvBZtgcf9KLs1GAeGiG7cePGrg/T9+8Ybi+spXcEXdoZ
         9AYw==
X-Gm-Message-State: AOAM531/d7cBqUMKEkICOkmsWbSY2PUUVAvAgvs8a9MnLJIbL1nWBMrU
        +eXlr8OZY49s2rXF3wWwsG5dETHYN1BJrqxAGopUtZbYINcvfHMY4vrccA4DzyWU7Twpw67LypA
        CM+av1xH/DxgdL/eLwVALbC1dODLEp/qI7wX+4osp5BozaFs5JHRu0RBbq+pj8t9XOHY7JoEDmV
        eRPbXcjrSZ77Q=
X-Google-Smtp-Source: ABdhPJzsplkDJ1yuYgTgRoHG2EJi8y8zaoVNMqyijoOGMN+RhJBCbc4vTxZST5sKYhUpKegqGjpUeQ==
X-Received: by 2002:a63:d315:: with SMTP id b21mr3384705pgg.331.1603394899933;
        Thu, 22 Oct 2020 12:28:19 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id s10sm2846759pji.7.2020.10.22.12.28.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 12:28:19 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [patch v4 0/5] scsi: Support to handle Intermittent errors
Date:   Thu, 22 Oct 2020 18:04:46 +0530
Message-Id: <1603370091-9337-1-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007a2ab505b24777b3"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000007a2ab505b24777b3

This patch adds a support to prevent retries of all the
io's after an abort succeeds on a particular device when transport
connectivity to the device is encountering intermittent errors.

Intermittent connectivity is a condition that can be detected by transport
fabric notifications. A service can monitor the ELS notifications and
take action on all the outstanding io's of a scsi device at that instant.

This feature is intended to be used when the device is part of a multipath
environment. When the service detects the poor connectivity, the multipath
path can be placed in a marginal path group and ignored further io
operations.

After placing a path in the marginal path group,the daemon sets the
port_state to Marginal which sets bit in scmd->state for all the
io's on that particular device with the new sysfs interface
provided in this patch.This prevent retries of all the
io's if an io hits a scsi timeout which inturn issues an abort.
On Abort succeeds on a marginal path the io will be immediately retried on
another active path.On abort fails then the things escalates to existing
target reset sg interface recovery process.

Below is the interface provided to set the port state to Marginal
and Online.
echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state


The patches were cut against  5.10/scsi-queue tree

---
v4:
Made changes in fc_eh_timed_out callout to set the SCMD_NORETRIES_ABORT if port
state is marginal 

With this change, we  removed the code  to loop over running commands
and fc_remote_port_chkready changes to set the SCMD_NORETRIES_ABORT 

Removed the scsi_cmd argument for fc_remote_port_chkready
and reverted back the patches that addressed this change(argument)

Removed unnecessary comments
Handle the return of errors on failure.

v3:
Removed the port_state from starget attributes.
Enabled the store functionality for port_state under remote port
Added a new argument to scsi_cmd  to fc_remote_port_chkready
Used the existing scsi command iterators scsi_host_busy_iter.
Rearranged the patches
Added new patches to add new argument for fc_remote_port_chkready

v2:
Added new error code DID_TRANSPORT_MARGINAL to handle marginal errors.
Added a new rport_state FC_PORTSTATE_MARGINAL and also added a new
sysfs interface port_state to set the port_state to marginal.
Added the support in lpfc to handle the marginal state.



Muneendra (5):
  scsi: Added a new definition in scsi_cmnd.h
  scsi: Added a new error code in scsi.h
  scsi: No retries on abort success
  scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
  scsi_transport_fc: Added store fucntionality to set the rport
    port_state using sysfs

 drivers/scsi/scsi_error.c        | 10 ++++
 drivers/scsi/scsi_lib.c          |  2 +
 drivers/scsi/scsi_transport_fc.c | 97 ++++++++++++++++++++++++++------
 include/scsi/scsi.h              |  1 +
 include/scsi/scsi_cmnd.h         |  3 +
 include/scsi/scsi_transport_fc.h | 19 +++++++
 6 files changed, 114 insertions(+), 18 deletions(-)

-- 
2.26.2


--0000000000007a2ab505b24777b3
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
BCADIaPpq59talxgO8fu2Aqys4U5x6uinFZYs/i6kEqMCjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMjIxOTI4MjBaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAG5SbsNxzrb+nJDw+
TcOMwxXPuJH4pHcB8zW7xnD3+vRdj75ZCI+bQctfoKGCoXfZltdFO0foJKaXDafMJf9M6uye559z
1AXBkKuFbJrwaSPJp15MfFnUX2iiZK9qIbvxRq8NBMCERuPn4BlofB4LHx5/bmkES19A2IOgSNUv
mdsdoR2IDJGJ6a8USRFCctO6GX++P4pnHYiGnGVdTuGqT+43ZPY8oVkfMg1zAj8NhjyJsbVr3EQn
QUB4zKRjCyRemgY6mm9iEyDp5Ta05RA+7dV7ak6uogVykwMs1GYEiz0TzKGKOJk7/TRwHKQR1tFy
SVHeae4xfexlDCAMruC3cg==
--0000000000007a2ab505b24777b3--
