Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B815BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 23:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbiA0XIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 18:08:02 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:27044 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiA0XIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 18:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643324881; x=1674860881;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RIc1G0jfMqESjsX/4a2c2KpqW6LjEkfd3i3QcfNLq/g=;
  b=g1pCKuF8QkATRKeP3LxjfKGRdLMqvqXF4g2urDxk3vmCeFuHO+TKLTOG
   uj4KoxoZer6EeqK7mKzLdnMSzuE0VlOGwYZmFHbINrCWXKCtqdPNdLmoi
   Qbok82mL0AZORBHE3nhCqdO4LASEADVsdZK8tgvCyfOSobmnXzFRujrHd
   QxMm/dkiNx23EIZZ8t1yBvSi84JsDf1V1M1Cx5sLNzd9E38Se2jvlUtSb
   ng0Brrd4ibJteX9s2ars2oVq2jEWLGcZDV4cnTBV51u9nldCPdBE4DvoQ
   vahdd52YGR2Ds5JmTBZpTtF3CptZJpIkBWL0g451ZHDJZAktce0HYM81a
   g==;
X-IronPort-AV: E=Sophos;i="5.88,321,1635177600"; 
   d="scan'208";a="190525323"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2022 07:08:01 +0800
IronPort-SDR: rAOGnb/v8DPMf4QZMs3ocL4ICOj6ORUnFTnZ9bQck9b0TNeikDXBpNDuxGl1wH5oGx5DAzff1h
 tIroVVvsst8KnHqcwQtA3wUFpDqSaVk4wtY0IbrLC57I6dXcVmI/T6TQvZlA6zY7Iv6vvC1t+j
 w+PhTofZyef9WEEumT6DYmRmKySnLhIlXp94dFLgn0U2vZkC0GMUXH3ieIvH7A85sw4/xna7uq
 fnPe5r8nxVbqfZwQbpCbZNbBgri8dc9myKYjeSqBI9GjxbUIh6DYyf5tCMZGyn3cV7pPR8O9MS
 eqYlZdRGdJiFRWsyomxKjKgC
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 14:40:04 -0800
IronPort-SDR: us/QJQQIPBtHP7H60BW5GZvQRtWTpwvkkSR0LyiT7NzRXcJTJWS5d4viKGiuD4WYY4FlBVqZDV
 8HA4wDTnK2Vl+tN8uanyhASxp5KbO97zHM08RwlKCEgobjwYYEOiWQOEUR15jo3BVJBjGhocA0
 Y8S3/LwcSzK0FCVTh5B4o5oKQXik+yM3uCSoy4B9IrA5EeOFMSeKnkBF3iMsR47XdTjN7iEGS/
 0l/wXsG+Mta+ioJ//D3p5sA/ZG3nVxhhUXbbukTJFdRe5nzAuN8q9pzDsnskYpWKQIHcCrupWz
 JPc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 15:08:01 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JlGTX73Vmz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 15:08:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643324880; x=1645916881; bh=RIc1G0jfMqESjsX/4a2c2KpqW6LjEkfd3i3
        QcfNLq/g=; b=I+8FNWGWJ/4MlV/z/th2/1EineZqntzCdjD1+SdzBRZmleDIasU
        bDQHm2D3NYjKWvvl7CP3MGFkpk50BSKIdgdpnDDD2k5ag+1jVp/eA7j0i8a6w59z
        ooUI+8JdH3Df02k9FxqaRt/DZp4KFOrK03D0VTm+psD1UCCZ5jmlNDll9dKF6Bn+
        rpVGWQ3hj3eHNz/juwNltJAuRiZFSHsXqL/lo/5+cVViCYFI6ttU2yc/TNrvF1He
        0CaT/njGqMqyEl7WmRJXWbOact3UD1oxAc2gtOSca0ice30aYLMyt6ak+SAqWbd8
        rbs6ZBWWS5OFBv5v6vtPbF2uLe8WfREwEuw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fx1c5MnfRBpg for <linux-scsi@vger.kernel.org>;
        Thu, 27 Jan 2022 15:08:00 -0800 (PST)
Received: from [10.225.163.58] (unknown [10.225.163.58])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JlGTW0WqXz1RvlN;
        Thu, 27 Jan 2022 15:07:58 -0800 (PST)
Message-ID: <6e698ebf-e592-dd44-95a2-8d86416277f7@opensource.wdc.com>
Date:   Fri, 28 Jan 2022 08:07:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/3] scsi: pm8001: Fix use-after-free for aborted TMF
 sas_task
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Ajish.Koshy@microchip.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viswas.G@microchip.com, chenxiang66@hisilicon.com
References: <1643289172-165636-1-git-send-email-john.garry@huawei.com>
 <1643289172-165636-3-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1643289172-165636-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/22 22:12, John Garry wrote:
> Currently a use-after-free may occur if a TMF sas_task is aborted before
> we handle the IO completion in mpi_ssp_completion(). The abort occurs due
> to timeout.
> 
> When the timeout occurs, the SAS_TASK_STATE_ABORTED flag is set and the
> sas_task is freed in pm8001_exec_internal_tmf_task().
> 
> However, if the IO completion occurs later, the IO completion still thinks
> that the sas_task is available. Fix this by clearing the ccb->task if
> the TMF times out - the IO completion handler does nothing if this pointer
> is cleared.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
> 
> Note: For hisi_sas driver we already do something similar. However there
> we also flush the completion queue interrupt to ensure that there is no
> race in clearing the task pointer. Please advise if/how something similar
> can be done here.
> 
>  drivers/scsi/pm8001/pm8001_sas.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 160ee8b228c9..32edda3e55c6 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -769,8 +769,13 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
>  		res = -TMF_RESP_FUNC_FAILED;
>  		/* Even TMF timed out, return direct. */
>  		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
> +			struct pm8001_ccb_info *ccb = task->lldd_task;
> +
>  			pm8001_dbg(pm8001_ha, FAIL, "TMF task[%x]timeout.\n",
>  				   tmf->tmf);
> +
> +			if (ccb)
> +				ccb->task = NULL;
>  			goto ex_err;
>  		}
>  

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
