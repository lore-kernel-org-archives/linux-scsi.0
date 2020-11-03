Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	MIME_NO_TEXT,SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DC9C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A301F22243
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MVGg8mLg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgKCOIj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 09:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbgKCOIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 09:08:37 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0F6C0613D1
        for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2020 06:08:37 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id x13so14274717pfa.9
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2020 06:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Ste+jlP0OvPL9pJvRXNNX/8x5v4VHYSjiyUMMCUb4dY=;
        b=MVGg8mLgLWESaW1ui9GzC6YNU4LduVJwQWj/f3T1z0qRUfTVCw7i5jti9qsl8mjpH8
         KyoHzalAC2L6q1E6Tc0E4gDLyJ3NhjlVy+vkNnwP69pItLnhCI+1bjCetRyyzTXL9XUz
         dyL/qELL4vK5RqLbu7j0MMUahjZvK36bI0pTg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ste+jlP0OvPL9pJvRXNNX/8x5v4VHYSjiyUMMCUb4dY=;
        b=pAyi7bxVyrXp8QRJZAnBWv3iKdopfkRXAffe5RDrjQBF2A95OBWjRbrn3MxxZAdwAB
         iwCRiT/BplCSEnyBTB/wsFY2HNabpe0SNSNDnp3ln2YW+vp2Kjbuk2nqC8th+02WELcG
         owWZ+8aDqLyZzzkph/hAW/UVufLOxwJghoNB81apAByVMa7zV38xJg9kU10ldEBMGupg
         VPvD6C2zLWx8BDV27jDspnIqQ6VgIQHlDlrhUfB+EsNOXFKr6efht76o6tQi4wujdaAn
         2l7OSyRSY3Nv2dv+ruD7yqqqmCOHMmek0HHxnEAFHNi/2qOD8yCfiTrj+lqBL/j4ZOYt
         kIHg==
X-Gm-Message-State: AOAM533bQjQybLPNtOAG5sCBE9lvkgmm8Npow+z3gSYOqXLtA3qH2p2Q
        bldio4q/hP0m/3lAPgJsKg7kUX5LLCdoxsEVHgQS9160lx/O8zEQMtXA6ogtuqPgX3heK+9oQa6
        f8INIiF5N34EXIjIIklsEufxLdLQQ6i+DTThm++hGJBq2yjJ1QKBFk5+DxY2Q59xyfMx18ITMTz
        8ktq2iSIeqyOg=
X-Google-Smtp-Source: ABdhPJxiwTuz4ulLVrzEK860NQhIYkua+i2jBhZPPkMyboNL3rDS6TMiw8+eF6/MfXOgYBq238rqhQ==
X-Received: by 2002:aa7:95bb:0:b029:152:b32d:6935 with SMTP id a27-20020aa795bb0000b0290152b32d6935mr26049523pfk.54.1604412515397;
        Tue, 03 Nov 2020 06:08:35 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id r19sm3525959pjo.23.2020.11.03.06.08.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 06:08:33 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [patch v5 0/5] scsi: Support to handle Intermittent errors
Date:   Tue,  3 Nov 2020 12:45:07 +0530
Message-Id: <1604387712-19801-1-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001689f005b33466a5"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001689f005b33466a5

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
v5:
Added the DID_TRANSPORT_MARGINAL case to scsi_decide_disposition

Made changes to clear the SCMD_NORETRIES_ABORT bit if the port_state
has changed from marginal to online due to port_delete and port_add
as we need the normal cmd retry behaviour while we are calling the
eh handlers.

Made changes in fc_scsi_scan_rport as we are checking FC_PORTSTATE_ONLINE
instead of FC_PORTSTATE_ONLINE and FC_PORTSTATE_MARGINAL


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

 drivers/scsi/scsi_error.c        |  17 +++++
 drivers/scsi/scsi_lib.c          |   2 +
 drivers/scsi/scsi_transport_fc.c | 103 +++++++++++++++++++++++++------
 include/scsi/scsi.h              |   1 +
 include/scsi/scsi_cmnd.h         |   3 +
 include/scsi/scsi_transport_fc.h |  19 ++++++
 6 files changed, 126 insertions(+), 19 deletions(-)

-- 
2.26.2


--0000000000001689f005b33466a5
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
BCA8AwzEa3GCCypHnpacYsXaDHlBARGFw3Bmx4uN/JW+AjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDMxNDA4MzVaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEANRjnuPZpu2YeUp2g
yTd9su3iZVdaBrfFNzMzJaq4tCnTMuEOjFJvkvnY8gWWpGbSS9BGYgNX27rtNHVht/KRQI/wQSyD
GU8+TiW4vqNjvTiIn0M+/PTCLw4SjriQfElEhKbA9M4Y55ev1tec9OXD2JfGY/LBjGuyWMRN3hYN
oOrTKIaSJXoZ1VW+zo+o/3TFPIQayadylIIcbsg6GIUS3An4w1oWMhE0ux8kAhoFAPKhAwHl6e6+
z8XNF35qv0Kg9moBp15H2mGu6XztRdtpa/vwHrzUUiluUGUiiTMik0JchxikwXuLQO6zHLe6fN3S
D/1gUGh3409g+/dPDZrtvQ==
--0000000000001689f005b33466a5--
