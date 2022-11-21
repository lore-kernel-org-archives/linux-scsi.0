Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC09C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 12:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiKUMeQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 07:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiKUMdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 07:33:53 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F18B54D4
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 04:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669033994; x=1700569994;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QzEDzoGLYNBf9zycRZ1H2wdknqfe6Bf1J8TFEUmSIxo=;
  b=a+BBWDb9xd2ONfc85DSGXHivfeKK0Caquo6nsCMgbNWrbgCAbEHInTiG
   4b2P6hY8AMPY//AC0x4AYWXf1zOxJVuzqjg+J8rTLng9J7uw/snAJVFiB
   pmnA8dx7PdiQM+eLIpzMzVxt+5MA89aaP/G0QZ7qKXbVAIln0hXgpfrCV
   IQx4u4JeR958XOdrRhTq61ejamHc9Yrs9krfXlxiJRnDiTWoNJvHnmDSQ
   UHkGzxQNSCfa5EZFpLzTE2tAhDhsc03CknJLVSfFJL6ndq3BihXQoEB0t
   Zu9Xh18bFs9atdsuJ6HZjyVphujE6JY5Qr9u/xUQQsopf6/IOrwmM/VN+
   w==;
X-IronPort-AV: E=Sophos;i="5.96,181,1665417600"; 
   d="scan'208";a="321137239"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Nov 2022 20:33:13 +0800
IronPort-SDR: UIiTBFQRAf5CZfJ8C1riZ5X8Ur8RtXZG4ItsbtR1Tt/YK5p6u3DCBJbXmnXe9nn0lo2UDImPUO
 ZrFYXIERz3RvZjQwSWxPJuWKmVABxQjhA/N3FqYvziVq+nJwE0n+Ni+zeHXmv6UuMlHqNmbdTP
 pDPs0UX+62roueIBw5GTLtFG29PEY+LnIShrJFQEzUCoEix9Nahing7Ype4rDYHmOwhMHVGLjX
 RLhMIti/GLaLUJmydePLcqYoh54qXJVSUAjakhIVBJCcTg4vrihkBgSsNjNiyox5+62T1vVkyh
 ce0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2022 03:46:18 -0800
IronPort-SDR: 4E4bek8pUN3bgdAToi2ypTzQSGvmx9rLIb3GxnIkSCcCXbk/5iPo7oTX6amDF5Fuu9mb5iPYK3
 CSpLwuRq6pbS47GRI6j8E7b632C244VMclLlpTDYJnSxPr9aZs2N5wrRYYx5ZXDomYGbRbDkVF
 UijnzojFAjVG5R2v9Ypc+V6Q0QUIAwGNzOr0r4zyXRU9XLjzX9jWn/r8iqORqltzVnQcOVaIkm
 TXupjY6ekMthfYPzvcOdmnLkfdGGUE2MqSXFZNX5wBmVunNX5XOkGHx038vvXx7Gn0IzZz7v6M
 mhg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2022 04:33:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NG6HY0qdDz1RvTr
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 04:33:13 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1669033992; x=1671625993; bh=QzEDzoGLYNBf9zycRZ1H2wdknqfe6Bf1J8T
        FEUmSIxo=; b=ggxmouGIAJ4x0zjPGwvDSIlsVrkcdtC9JTLejcdl4W2FmXH9WOO
        G8O3350RoVPlhe5FdiajXwWtuwAO3v5r8GFKycGLG+N82U4ulwWNE96ba8ZPbY9w
        JL1tn+EJCdtD/lGj9krvr6qZlzbeCcNaMjDA3eVFRcVs03FNh/nWXwhxj/96uN6V
        thL1nWh96+Jyl8KRQawtO3oIAIO1fBJzXoYwlVcP+Iq/t7GzbpM7JOStPtyaZHN5
        LPolUCkNmEyxyXMkC/cJ2ccQxhwmhk5KK7ym8MWL1qBzd2tT+sN+wsqnFzviscjb
        ewrpQlcM+6AnQX88Sr5dIgurb+54jfFd6Ew==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fSCayNAsrUcT for <linux-scsi@vger.kernel.org>;
        Mon, 21 Nov 2022 04:33:12 -0800 (PST)
Received: from [10.225.163.53] (unknown [10.225.163.53])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NG6HW6clhz1RvLy;
        Mon, 21 Nov 2022 04:33:11 -0800 (PST)
Message-ID: <83c29cc2-9bf4-265f-4f8a-ab83d8b6271b@opensource.wdc.com>
Date:   Mon, 21 Nov 2022 21:33:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/2] scsi: core: Use SCSI_SCAN_INITIAL in
 do_scsi_scan_host()
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221121121725.1910795-1-john.g.garry@oracle.com>
 <20221121121725.1910795-3-john.g.garry@oracle.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221121121725.1910795-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/21/22 21:17, John Garry wrote:
> Instead of using hardcoded '0' as the do_scsi_scan_host() ->
> scsi_scan_host_selected() rescan arg, use proper macro SCSI_SCAN_INITIAL.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/scsi_scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6cc974b382c1..920b145f80b7 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1920,7 +1920,7 @@ static void do_scsi_scan_host(struct Scsi_Host *shost)
>  			msleep(10);
>  	} else {
>  		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
> -				SCAN_WILD_CARD, 0);
> +				SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
>  	}
>  }
>  

-- 
Damien Le Moal
Western Digital Research

