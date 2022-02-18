Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155DEC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 08:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiBRImS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 03:42:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiBRImP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 03:42:15 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A2E27D692
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 00:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645173719; x=1676709719;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RkWPgnntRBIJrukZERi0LIGEb+cTW3ymJGoDQuQUAYw=;
  b=Bri24VY2pL9ANOA+HdT9bTJumKlOCLPcSo8Y+fENT/CR2xY7N0a+waPf
   7CduJpAE9l6T/32bhvSYOeXCGdgO8mIJ9FIyoJv/4gOvzKiqXUlNy38pt
   SM7FXv96WT5b+rriwatjrD2sEoCIM/N9WosQgJBuNBePx5RI1fJYpVjoc
   gxWPrbEyvun0R8fgjijEe8FTcpxraU/AyFVFWF1AmIcX4XLKug0vPTO7Z
   WGx/IOvvaJ0ZECWHYXsoNsHbfCbs7s4jDr8sjB9b7zwRJ7wL0iyTeGua4
   aOy+cf15KFU3krATvnBjVPLi13Gk7cuvPNcm6/Gu/phu8OiedxdKgiLlT
   g==;
X-IronPort-AV: E=Sophos;i="5.88,378,1635177600"; 
   d="scan'208";a="297384526"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 16:41:58 +0800
IronPort-SDR: VtQ3O4E2Nf/DjAGu1RBZjjv7hn0/o1aSLYf3edK4dNs/5AdAg82YE/K2gSCG813u9okDr95FgY
 w/IJGAsszvk1DBVVUailZK3Fo0u5nuuhY4S7fflV3f2ww6iXaEN+6GWo9dPR85SX1CjVDARX4F
 1ckcsAjlOvYpqUbnN5BvFwWtxos2A5aKQMi2WKbAm57WDXsHkzfYDVzyshhokCcFwKDFLLEqxu
 uI2T+1b+DYGXR1Dc0p88eAheWz6x8LrBtmk+rQtsRiLzCCpiV3cC0K/p00lCfQhcMFOC5McU0b
 oeLVj/gprwuZBMrpfJg8+vLB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 00:13:36 -0800
IronPort-SDR: ijdcNRjN5inMUDlQOe9v/tIXu+kxwJh5vhwibMDPYyGAGMVpzBdEquq6m7J+xqABHLFrs6Nd0Z
 V3rpMbmRRTOMMePJSM9AkdRabLKJOIBmx97qK/5z1GRHlvyKvaB4uN0zRSMcu1X55upXSpR1g+
 8tcBok9YPpRTLOpFYIm8HR2PCgEbCS6aTd4gS0e1d1LVgBf9QESR7gCtNSkfhXNP9uJ8uVXfi2
 7fiTPeQx4W00IMiyycH3wC1RVIPdxQqZotX2VZwM3BMv4LH7j5ACz2AC57D6C9sDDkIOqG7mo9
 DJo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 00:41:59 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0QD62RSSz1SVp0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 00:41:58 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645173717; x=1647765718; bh=RkWPgnntRBIJrukZERi0LIGEb+cTW3ymJGo
        DQuQUAYw=; b=XaN2ZUjC6z1kEN58M/Apd7mmmnwiN9VVTzrWCQxKFGF/1Ctqg6J
        SWO/8awL6aSegvarw9JSGWG63PtERJF69K2DdF0iwsGzxwKmsiDh1wI2s2Ai9Jlk
        a45mu657shjEpge6FHHWhoizHYwsdoTBEx38hYXcdFIlrBYOEcJYBSeMFDL0JFBL
        N+bB622Adjw5uSbh0BtT+xU0ZL97Y8HOBPNj8sQ9HIoU3LUcJNvcVbxskUO/SkE9
        eO+PElzb7OQ6S3t823Ru3TdQqdVda4XoOmUmmLXq8GlQLOiLoSryD3pCFzPq+1pY
        rAbhEZ31vp0omMqTH/eYSPNq+NSN+bI4VIA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qKGdf5tacCdq for <linux-scsi@vger.kernel.org>;
        Fri, 18 Feb 2022 00:41:57 -0800 (PST)
Received: from [10.225.163.78] (unknown [10.225.163.78])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0QD46czNz1Rwrw;
        Fri, 18 Feb 2022 00:41:56 -0800 (PST)
Message-ID: <f2c5943b-c576-8cae-5d53-20fb524f366f@opensource.wdc.com>
Date:   Fri, 18 Feb 2022 17:41:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] scsi: pm80xx: handle non-fatal errors
Content-Language: en-US
To:     Ajish Koshy <Ajish.Koshy@microchip.com>, linux-scsi@vger.kernel.org
Cc:     Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20220218075627.54589-1-Ajish.Koshy@microchip.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220218075627.54589-1-Ajish.Koshy@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/18/22 16:56, Ajish Koshy wrote:
> Firmware expects host driver to clear
> scratchpad rsvd 0 register after non-fatal error
> is found.

Please use up to 72-ish characters per line.

> 
> This is done when firmware raises fatal error interrupt
> and indicates non-fatal error. At this
> point firmware updates scratchpad rsvd 0 register
> with non-fatal error value. Here host has
> to clear the register after reading it during non-fatal
> errors.
> 
> Renamed
> MSGU_HOST_SCRATCH_PAD_6 to MSGU_SCRATCH_PAD_RSVD_0
> MSGU_HOST_SCRATCH_PAD_7 to MSGU_SCRATCH_PAD_RSVD_1
> 
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 28 ++++++++++++++++++++++------
>  drivers/scsi/pm8001/pm80xx_hwi.h |  9 +++++++--
>  2 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index bbf538fe15b3..df22cfd07262 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1552,9 +1552,9 @@ pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha)
>  {
>  	int ret = 0;
>  	u32 scratch_pad_rsvd0 = pm8001_cr32(pm8001_ha, 0,
> -					MSGU_HOST_SCRATCH_PAD_6);
> +					MSGU_SCRATCH_PAD_RSVD_0);

I know the code is full of such style, but could you please indent the
function arguments together ? that is:

  	u32 scratch_pad_rsvd0 = pm8001_cr32(pm8001_ha, 0,
					    MSGU_SCRATCH_PAD_RSVD_0);

This makes the code far easier to read.

>  	u32 scratch_pad_rsvd1 = pm8001_cr32(pm8001_ha, 0,
> -					MSGU_HOST_SCRATCH_PAD_7);
> +					MSGU_SCRATCH_PAD_RSVD_1);

Same here, and many places below too.

>  	u32 scratch_pad1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
>  	u32 scratch_pad2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
>  	u32 scratch_pad3 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
> @@ -1663,9 +1663,9 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
>  			PCI_VENDOR_ID_ATTO &&
>  			pm8001_ha->pdev->subsystem_vendor != 0) {
>  			ibutton0 = pm8001_cr32(pm8001_ha, 0,
> -					MSGU_HOST_SCRATCH_PAD_6);
> +					MSGU_SCRATCH_PAD_RSVD_0);
>  			ibutton1 = pm8001_cr32(pm8001_ha, 0,
> -					MSGU_HOST_SCRATCH_PAD_7);
> +					MSGU_SCRATCH_PAD_RSVD_1);
>  			if (!ibutton0 && !ibutton1) {
>  				pm8001_dbg(pm8001_ha, FAIL,
>  					   "iButton Feature is not Available!!!\n");
> @@ -4138,9 +4138,9 @@ static void print_scratchpad_registers(struct pm8001_hba_info *pm8001_ha)
>  	pm8001_dbg(pm8001_ha, FAIL, "MSGU_HOST_SCRATCH_PAD_5: 0x%x\n",
>  		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_5));
>  	pm8001_dbg(pm8001_ha, FAIL, "MSGU_RSVD_SCRATCH_PAD_0: 0x%x\n",
> -		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_6));
> +		   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_RSVD_0));
>  	pm8001_dbg(pm8001_ha, FAIL, "MSGU_RSVD_SCRATCH_PAD_1: 0x%x\n",
> -		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_7));
> +		   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_RSVD_1));
>  }
>  
>  static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
> @@ -4162,6 +4162,22 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  			pm8001_handle_event(pm8001_ha, NULL, IO_FATAL_ERROR);
>  			print_scratchpad_registers(pm8001_ha);
>  			return ret;
> +		} else {
> +			/*read scratchpad rsvd 0 register*/
> +			regval = pm8001_cr32(pm8001_ha, 0,
> +					MSGU_SCRATCH_PAD_RSVD_0);> +			switch (regval) {
> +			case NON_FATAL_SPBC_LBUS_ECC_ERR:
> +			case NON_FATAL_BDMA_ERR:
> +			case NON_FATAL_THERM_OVERTEMP_ERR:
> +				/*Clear the register*/
> +				pm8001_cw32(pm8001_ha, 0,
> +					MSGU_SCRATCH_PAD_RSVD_0,
> +					0x00000000);
> +				break;
> +			default:
> +				break;
> +			}
>  		}
>  	}
>  	circularQ = &pm8001_ha->outbnd_q_tbl[vec];
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index c7e5d93bea92..f0818540b2cd 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -1366,8 +1366,8 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
>  #define MSGU_HOST_SCRATCH_PAD_3			0x60
>  #define MSGU_HOST_SCRATCH_PAD_4			0x64
>  #define MSGU_HOST_SCRATCH_PAD_5			0x68
> -#define MSGU_HOST_SCRATCH_PAD_6			0x6C
> -#define MSGU_HOST_SCRATCH_PAD_7			0x70
> +#define MSGU_SCRATCH_PAD_RSVD_0			0x6C
> +#define MSGU_SCRATCH_PAD_RSVD_1			0x70
>  
>  #define MSGU_SCRATCHPAD1_RAAE_STATE_ERR(x) ((x & 0x3) == 0x2)
>  #define MSGU_SCRATCHPAD1_ILA_STATE_ERR(x) (((x >> 2) & 0x3) == 0x2)
> @@ -1435,6 +1435,11 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
>  #define SCRATCH_PAD_ERROR_MASK		0xFFFFFC00 /* Error mask bits */
>  #define SCRATCH_PAD_STATE_MASK		0x00000003 /* State Mask bits */
>  
> +/*state definition for Scratchpad Rsvd 0, Offset 0x6C, Non-fatal*/
> +#define NON_FATAL_SPBC_LBUS_ECC_ERR	0x70000001
> +#define NON_FATAL_BDMA_ERR		0xE0000001
> +#define NON_FATAL_THERM_OVERTEMP_ERR	0x80000001

Could you align the values similarly to other macros above and below
this hunk ? Again, code readability.

> +
>  /* main configuration offset - byte offset */
>  #define MAIN_SIGNATURE_OFFSET		0x00 /* DWORD 0x00 */
>  #define MAIN_INTERFACE_REVISION		0x04 /* DWORD 0x01 */


-- 
Damien Le Moal
Western Digital Research
