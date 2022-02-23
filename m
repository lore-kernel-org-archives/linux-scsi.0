Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB27C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 00:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiBWAsM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiBWAsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 19:48:11 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D41C33A24
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 16:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645577264; x=1677113264;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wJUKx/KkD4+CXKvwDZ0ieAmL9cOueVuJlEV/sfKMqts=;
  b=LwV9nhOYALAFYT/5Bfx1GMke1lLEgDOs/sCU873gf0tRVBRTBcdpkFeo
   8cv3UiPgFC0jExuWtZhPa2Qk7jnXpXur9Df7MsWqgz+Ng2Ebj95YDf7jh
   lSsEbBEcpn5iEHqddNI6zilF8kVm/aSgon/SrkyheG5PA+DEEkwaQXAzD
   boPB9PzzybAy4fMq/oSgs5nxnEPG1D2XV2USMjGT/2jbOvinbqxsIm+gR
   /L3iJzNj3FKSeXd1XjIlHEIOpgTZR3Bn0d65hoVKmxbT40Ljuf04bwVkN
   kuiLqM1Q0zeT0lnIBi7+UjJ3UGzTRZl6ktZgHAoqI49JXWYPpv3USdPE6
   g==;
X-IronPort-AV: E=Sophos;i="5.88,389,1635177600"; 
   d="scan'208";a="193715717"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2022 08:47:43 +0800
IronPort-SDR: 6RCUz6dx5/j5C4iUdRec5pELzHt4dEUymgymjquVwMcPbpJ5UVFlDWiIOwRsyb2e4Fe/i0rP1t
 I4X1CKO/BMTL6zIlC7SVChiEKdBvRJ8Tpb2PZgTqSLmvYmcfUqvPqmaLWMeH00lQYaz/fphCkB
 N1j8P1aJ9feoNQp7W32V7HtlHJrQY5+7DGx4IONtohT1xNBwezB4hqHgyBqNCnBCxmJvTEYPXT
 dTqsESCyoNTpvRS1jDVbRTHuYm3bG0aeWbRgFLKgRz2szlxsRG3fECfOooBIUKF/dhWuxf/qpQ
 Vma07ZxjuSjt7Sc8SCr4hiMw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 16:19:16 -0800
IronPort-SDR: clXIpD664K/5qRBD4SGDWFRzodePoptlBsrsGUdrePWuRp+3v+ijffaht3AmuCn8D7HyOLjW4p
 uWLcgbqwsbPw4lQ6VP9uNX9PAeJ2lACvLFm0PbQbOQmi2iGAGnm8THv01/7s0/9SJwKw7m++k/
 QnYKfeW2YCqQnghxKYQ4IkHSYe0GNfdr98Qd63eYN7EUdknldf3n9YPwgYJi9nL2gID33olZV/
 17gSPQnEYvpTEkH0oraIn0FFDXDGW/+M0CdmskADExJS/CVJd1vU/KgO/jk+I8vINsjgW/lcSB
 QIo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 16:47:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K3HSb3YPNz1SVnx
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 16:47:43 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645577262; x=1648169263; bh=wJUKx/KkD4+CXKvwDZ0ieAmL9cOueVuJlEV
        /sfKMqts=; b=hxSrJkPrJrAFBFIPmNSSEbzvU7EPSPM1zPbhEdTJR120KVojPRN
        u+r8to+hPckawZC/eKEvDrR/IUHGtOhysqaiQSvcfdshTdwtGfoEBA8iPd5N3uSS
        19ThmSTUQvd/j8XQ8CSCzJLb9t7gqxIx33EI6elx/KWJ/v0DRO81gAu6NSKA2wzw
        YgaSKIL9jKp8ce4cqnLEkk+VJAt/h8oSZYcuwTjFwV5/HQZyGxdsB1l6ZKRb7C0v
        G28CwbOL4FibWzksTkldEUwBH2gC3/w0iE+zTzJ00a1HrgLzHrCl89BlqOdm7MPu
        pF0lM1SmN1ypacpfUgU2fJNAJ+e+MduvOkA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id y5p5ePButJF5 for <linux-scsi@vger.kernel.org>;
        Tue, 22 Feb 2022 16:47:42 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K3HSZ0QY7z1Rvlx;
        Tue, 22 Feb 2022 16:47:41 -0800 (PST)
Message-ID: <2ad7f76c-a14b-6cae-942a-b93d792a8034@opensource.wdc.com>
Date:   Wed, 23 Feb 2022 09:47:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] scsi: pm80xx: handle non-fatal errors
Content-Language: en-US
To:     Ajish Koshy <Ajish.Koshy@microchip.com>, linux-scsi@vger.kernel.org
Cc:     Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20220222092618.108198-1-Ajish.Koshy@microchip.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220222092618.108198-1-Ajish.Koshy@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 18:26, Ajish Koshy wrote:
> Firmware expects host driver to clear scratchpad rsvd 0 register after
> non-fatal error is found.
> 
> This is done when firmware raises fatal error interrupt and indicates
> non-fatal error. At this point firmware updates scratchpad rsvd 0
> register with non-fatal error value. Here host has to clear the register
> after reading it during non-fatal errors.
> 
> Renamed
> MSGU_HOST_SCRATCH_PAD_6 to MSGU_SCRATCH_PAD_RSVD_0
> MSGU_HOST_SCRATCH_PAD_7 to MSGU_SCRATCH_PAD_RSVD_1

Naming these registered "reserved" is very unfortunate since that
generally means the they should not be touched at all...

In any case, this looks OK to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> 
> Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 28 ++++++++++++++++++++++------
>  drivers/scsi/pm8001/pm80xx_hwi.h |  9 +++++++--
>  2 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index bbf538fe15b3..9fcc332d685b 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1552,9 +1552,9 @@ pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha)
>  {
>  	int ret = 0;
>  	u32 scratch_pad_rsvd0 = pm8001_cr32(pm8001_ha, 0,
> -					MSGU_HOST_SCRATCH_PAD_6);
> +					    MSGU_SCRATCH_PAD_RSVD_0);
>  	u32 scratch_pad_rsvd1 = pm8001_cr32(pm8001_ha, 0,
> -					MSGU_HOST_SCRATCH_PAD_7);
> +					    MSGU_SCRATCH_PAD_RSVD_1);
>  	u32 scratch_pad1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
>  	u32 scratch_pad2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
>  	u32 scratch_pad3 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
> @@ -1663,9 +1663,9 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
>  			PCI_VENDOR_ID_ATTO &&
>  			pm8001_ha->pdev->subsystem_vendor != 0) {
>  			ibutton0 = pm8001_cr32(pm8001_ha, 0,
> -					MSGU_HOST_SCRATCH_PAD_6);
> +					       MSGU_SCRATCH_PAD_RSVD_0);
>  			ibutton1 = pm8001_cr32(pm8001_ha, 0,
> -					MSGU_HOST_SCRATCH_PAD_7);
> +					       MSGU_SCRATCH_PAD_RSVD_1);
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
> +					     MSGU_SCRATCH_PAD_RSVD_0);
> +			switch (regval) {
> +			case NON_FATAL_SPBC_LBUS_ECC_ERR:
> +			case NON_FATAL_BDMA_ERR:
> +			case NON_FATAL_THERM_OVERTEMP_ERR:
> +				/*Clear the register*/
> +				pm8001_cw32(pm8001_ha, 0,
> +					    MSGU_SCRATCH_PAD_RSVD_0,
> +					    0x00000000);
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
> +
>  /* main configuration offset - byte offset */
>  #define MAIN_SIGNATURE_OFFSET		0x00 /* DWORD 0x00 */
>  #define MAIN_INTERFACE_REVISION		0x04 /* DWORD 0x01 */


-- 
Damien Le Moal
Western Digital Research
