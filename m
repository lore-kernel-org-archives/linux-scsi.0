Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA4AC4363D
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A32D22258
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MfxqcBri"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390049AbgJIROZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 13:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731521AbgJIRON (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 13:14:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326D6C0613D2
        for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2020 10:14:13 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g10so7393194pfc.8
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 10:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=p5TDwZMK3aPJQRCrERPtqdSFeH5p465wGpx/OMeD4YY=;
        b=MfxqcBriiCxBANyq9pWTJxLY62B1YSj3YPiQOdyC1TvDEKgbXfzfD+AqZ4RDFWeWiu
         uyYxuG0+kAM1BwcEHCPJehoRRrZ/9oaw1Xs58kJ/ocCymXVw8JE9F2uw1vo7P/teZDQq
         z/Qxj0UfBKh6N4TwYeE3Gv18Q4CwlYjHX0Tiw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=p5TDwZMK3aPJQRCrERPtqdSFeH5p465wGpx/OMeD4YY=;
        b=r7Vf5+d4SFPb9H/8AfI/SRBpXAhhOB6IOxkgDq59J262JXQlvWttGAwNhwptJ7UQg6
         zR8L2r7cNq3lWh1w/OeB2A7s0c7bPmVd0UDDzjCYn8SNe15GiCk2u1f2hR02J+0BoiWw
         OnQopMxU7Ts8/zDlwtREnpjshCNGUdGBNqP11KQC3td8r3I2p7L66dxPTjOyTo4A3bQj
         mCFsrn7lS5qlgadEP22emdfj5/1/jtQXqzBtv6tISCqbqOtfYL6El/khlyEmM2/A9/Rs
         6qi5kaKQOcZ7gfakURo7zpGE3VOmvUgl3NqnoSfCWiv4VVMzZoTXDIUM0Mv7KuH7h9wL
         OTRg==
X-Gm-Message-State: AOAM5339xzA4blMqtoqlxsByjB/LDtprm2UtG5BnUSOjlUrIim3LPftj
        OWm86BBe9kL18y3Ysn8Izsb10A==
X-Google-Smtp-Source: ABdhPJxJ79/1SgZcNIO4M/EesYZ+JlIyhKyqDHwwus6koJk5eepA50ySzDq0n97KCyQalmF6nDxMPA==
X-Received: by 2002:a63:a55c:: with SMTP id r28mr4007526pgu.177.1602263652347;
        Fri, 09 Oct 2020 10:14:12 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id fy24sm12299055pjb.35.2020.10.09.10.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:14:10 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 00/14] mpt3sas: Add support for multi-port path topology
Date:   Fri,  9 Oct 2020 22:44:26 +0530
Message-Id: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000df8ef805b14013d2"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000df8ef805b14013d2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Multi-port path topology example:
    
         Zone 1             Zone 2
 |-----------------|   |----------------|
 |  HD1 ..... HD25 |   | HD26 ......HD50|
 | |==================================| |
 | |               |   |              | |
 | |              Expander            | |
 | |==================================| |
 |           |     |   |    |           |
 |-----------|-----|   |----|-----------|
           x8|              |x8 
      _______|______________|_______
      |            HBA             |
      |____________________________|

In this topology, zoning is enabled in such a way that drives from HD1
to HD25 are accessible only through zone1 and drives from HD26 to HD50 are
accessible only through zone2. Here the first x8 connection bw HBA to
Expander in zone1 will have one PortID and second x8 connection bw HBA to
Expander in Zone2 will another PortID.

Problem statement:
When zoning is enabled in expander then we will have two expander
instances (for a single real expander), one instance is accessible through
the first x8 connection and second instance is accessible through
second x8 connection from HBA. But for both the instances the
SAS Address of the expander will be the same.
But in current mpt3sas driver, driver add's only one expander instance,
when second expander instance's 'add' event comes then driver ignores
this event assumues that it is duplicate instance as it already
has a sas_expander object in it's sas_expander_list list with
the same SAS Address. So in this topology users will see only 25 drives
instead of 50 drives.

Current mpt3sas driver use ‘SAS Address’ as a key to uniquely identify
the End devices or Expander devices, but on the multi-port path topologies
(such as above topology) HBA firmware will provide multiple device entries
with different Device handles for a single device.
So here driver can't use ‘SAS Address’ as a key instead driver can use
‘SAS Address’ & ‘PhysicalPort (i.e. PortID)’ number as key to uniquely
identify the device.

where, PhysicalPort is a HBA port number through which the device is
accessible.

Solution:
Now driver uses both 'SAS Address' & 'PhysicalPort' number as a key to
uniquely identify the device object from the corresponding device
list's. So, when 'add' event comes for second instance of expander,
now driver can't find the sas_expander object with same 'SAS Address' &
'PhysicalPort' number (since for this second instance PhysicalPort
number will be different from first instance's PhysicalPort number)
from the sas_expander_list list. So the driver processes this event and
will create a new sas_expander object for this expander instance
and adds it sas_expander_list.
With this solution, the driver will have two sas_expander objects, one
object is for the first instance of the expander, another object is for
second instance of the driver. Now users will access all 50 drives from
above topology.

Like device SAS Address, PhysicalPort number is readily available
from below config pages,
* SAS IO Unit Page 0,
* SAS Device Page 0,
* SAS Expander Page 0,
* SAS Phy Page 0, etc

Through this patch set, the driver now manages the sas_device &
sas_expander objects using 'SAS Address' & 'PhysicalPort'
number as key.

Sreekanth Reddy (14):
  mpt3sas: Define hba_port structure
  mpt3sas: Allocate memory for hba_port objects
  mpt3sas: Rearrange _scsih_mark_responding_sas_device()
  mpt3sas: Update hba_port's sas_address & phy_mask
  mpt3sas: Get device objects using sas_address & portID
  mpt3sas: Rename transport_del_phy_from_an_existing_port
  mpt3sas: Get sas_device objects using device's rphy
  mpt3sas: Update hba_port objects after host reset
  mpt3sas: Set valid PhysicalPort in SMPPassThrough
  mpt3sas: Handling HBA vSES device
  mpt3sas: Add bypass_dirty_port_flag parameter
  mpt3sas: Handle vSES vphy object during HBA reset
  mpt3sas: add module parameter multipath_on_hba
  mpt3sas: Bump driver version to 35.101.00.00

 drivers/scsi/mpt3sas/mpt3sas_base.h      |  102 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |    6 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 1237 +++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  312 +++++-
 4 files changed, 1455 insertions(+), 202 deletions(-)

-- 
2.18.4


--000000000000df8ef805b14013d2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
Rag/s/0IKyxAQsoBcla5ZufuDE5ir/mlnYktkPJdg+kns/OPDsINSyWqNYE9PKy9+3cp/fItNFtH
krg1AgMBAAGjggHTMIIBzzAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsG
AQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2ln
bjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29t
L2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEF
BQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBE
BgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWdu
MnNoYTJnMy5jcmwwJwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNV
HSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4E
FgQU1CyhXqcQo40SZ7kFS/AiOnRW6lMwDQYJKoZIhvcNAQELBQADggEBAFeMmmz112eNFAV8Ense
5WremClV5F3Md1xS0yXKqxlgakUJaOI/Fai7OLQaQqsEoxW6/QqWEi1wbZOccbdritOkL5b7sVUp
SU9OfuIlV8c3XMLaWSIluy+0ImtRJ49jDCI4KtQESHrqfQRZcc1C/avZvNED3U4b10U6N3SY+59b
fm2Vlwacwp+8ESTp49DsLcJqc4U/0rUZxLWtgPokzS+ovX+JAu8zx1SmOzUC4hj4Bp6Vnfd5KWUK
JJQBmQHXii+acSeTgHmPWUYs3tYQ0uIX0Yy8LUWPdGbEq+KWepzY2otC+iVWdngCCv8Nf1Xo1jki
AGJ6hrlWFE0qJVWv25sxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hB
MjU2IC0gRzMCDBmG1a14/wFg8qBhUjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg
dT+CJaad1OPgAGohJLysxSvAB0dwiotgUwCUCb2D2FUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDA5MTcxNDEyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAB+PTaBQLY/TcD4I7ygE
l6FTjUn/5r8xb3xDt0v2BaMkjNEGTR57sCLTFXAZUvW7yin2+fE05t6s5bgHJpkIFrDeTx2Zo82D
shJyq5jePSevEGBG3kPszWtv4kzb7j6ii6SxCYFPQRQWZQM3rkpRGT2Y7mOPCTZtZA+7kCDOfLiU
84rcrLNWZm6qZ6dWHhYyGtsy532BAnZMf7uFWc1N3qgOOenwrWm5MuF2nvWQXZSIO8eKLS0uPumd
/Kv7aU8G6g8pDJ86fLdsuwUX7rxmbOoLaifNKuykc1fqYN1uovvw1tSbBtzdIogFn7Uw0jY4mfmy
FBcq+hmSkvs6mhmam3Q=
--000000000000df8ef805b14013d2--
