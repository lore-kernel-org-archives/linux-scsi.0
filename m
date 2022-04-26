Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87947C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 10:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346665AbiDZKtc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 06:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349731AbiDZKtM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 06:49:12 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7B712744
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 03:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650969893; x=1682505893;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1fG4PwErFffi/pazb2bawKfkJk5sVpNk9cM7Og8tYmk=;
  b=aAaT6095Ic3hVq05ShOScbwIEc+F91sZsJQaIOTEIM7c9xSjDtHTclUb
   P1W0Yb/D7Qxf9/KKuh+dc2YeSU4PJyKPoqdLKa7l841FZ6AzAHklDHtn2
   YCAFlKGJTM4+h2uV5Lz2Ji8tE0hMbppwNWbQepLm538z5D7S5JvnSof3L
   NviWRaqCZZky2Kd41CpVmilcVxCmDbYa96SHOh4qgP08CR9IhUZZmqjPE
   zfQ8/DhWuUJ5uNBRznfPxdhvl9E0zG1bDRYlT1rU/C6v/DhKR5bgeKwOi
   aRLSc/lSTx2znGdL65shxd+p3OefseIU4vuadyQLXAjMnkxPXCDwQUtVQ
   A==;
X-IronPort-AV: E=Sophos;i="5.90,290,1643644800"; 
   d="scan'208";a="310815445"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Apr 2022 18:44:52 +0800
IronPort-SDR: dxsBLOlfps6C7hnXNvJLg/xGn+vgnYXZyxP1qpj7NXqYUFGnfm3N/Cqdt13IhvLhaJMkFbYC8i
 F6qnViB0ZXmIif1HZlthVEZIwHqesHMK1uW/m705b3PmKDXKad1qxO9YmFL2ThuXPSTwlguQRY
 DWbZxJwmC0TI8HZlSWPRyy/SjWvsWAhW/vcBkpqC0b0vXn5cvYfXqLG6CKI9e48SmMcwXSRj1V
 Tpb41UoCK2JE+yd9Ng4Wc7pTX3KKSPJx5Gu3ryy8x1ImAnGjN0OcUeEIobBC4//ywQ4xq3mD1N
 mjz3BQdPaTj60dTCealdlvt4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Apr 2022 03:15:04 -0700
IronPort-SDR: ZIRzBJF/uPxQTDvrKcLjJS0OMJiOuyDlpogBk2/0TN2sFJ2VFfxjDL3T0A+kF9w/OLXxKP11U8
 jH0BFnqFSzYT5cvXCbFk87JedF8PO9dAr+m31f7Ndu+QKpKFv4TN77KUblmNDO6eLlNTGrzC4U
 sGyjdA57M1u+/iqsIudyq9YfaL0J7j3vO6JviddMAI0xahX1mktkEDWjH5WwJQqcpq1QwB6FuM
 +16vXzt5DCdDEQ5+wlYz1CDGrfD2ORXSgeU6YtcxmwE6fDbnDC9+gQajVBO1BgWuwhcSL6E0IT
 7wM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Apr 2022 03:44:53 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kndn02jkmz1SVnx
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 03:44:52 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650969891; x=1653561892; bh=1fG4PwErFffi/pazb2bawKfkJk5sVpNk9cM
        7Og8tYmk=; b=bEGOCMFkMFUHp3ioIlw56CBQXcdmnxBD0Q96OWQiZcvj7QPIH12
        gwb12CYxnwlV3UBuJwSI/GRT8DV0pEVN9tUhtBxxEXKUh0BQ9nEHK0GoUCShLLQv
        cWvrb2KInHwal7f//Nem/LYdM1CiBkZowxfxPsSmMuZX1NOmcub6g52JBzKIC1el
        ymThZgZJlSHVffhhJ8MDoAZ5llEHy5kTSRHOmw182vp9PL/2mwJLJ8lwZkF/69EX
        zoAX2UpUK/3Fb489MII1wSQdcBGJzVQWTipnM6sS0TMd3U0kDiGX46l0CTgiTppY
        HGFIbWNJPgnXZ0jEy10WH5onJrntNCESL5Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KBZ7-Q2QP0_9 for <linux-scsi@vger.kernel.org>;
        Tue, 26 Apr 2022 03:44:51 -0700 (PDT)
Received: from [10.225.163.24] (unknown [10.225.163.24])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kndmz0R4Qz1Rvlx;
        Tue, 26 Apr 2022 03:44:50 -0700 (PDT)
Message-ID: <06144972-8f85-c791-8eec-71a994d83c7c@opensource.wdc.com>
Date:   Tue, 26 Apr 2022 19:44:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
 <a1293ec4-d160-9ebb-d20c-d120b14e6da6@opensource.wdc.com>
 <yq1ilqwuo5r.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <yq1ilqwuo5r.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/22 19:37, Martin K. Petersen wrote:
> 
> Damien,
> 
>> Can we get this one queued for 5.19 ?
> 
> It's already in scsi-staging. Had some mail problems so not all merge
> notifications went out.
> 

OK. Thanks !

-- 
Damien Le Moal
Western Digital Research
