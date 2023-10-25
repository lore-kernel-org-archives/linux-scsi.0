Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45533C0032E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 13:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbjJYNeE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbjJYNeD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 09:34:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F76B4
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 06:34:01 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39PDMbGk024940;
        Wed, 25 Oct 2023 13:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=jZaRLgE68Ppj2g4flSRknnaTgbKqqGmPoWWpYBC8mBE=;
 b=ffJYK+87zUF3HVJhuauN0kUsAeIPEbCzSrBFsyLfxqlvmL9gy3Cdf4Ww80cJKNRU+c01
 lkdn1xs0/K31w9a97FoD2jsZvhbvDClXf6ZNXJcdO0qv9aRq7mQzcayOxoYGbCx3VprC
 XeZJofDBQhFJ+Xdlmz2ISEVY7LQjZFT/V8MrP/FlvVI7+IfP5sfuKyPUH0BfYi5oRNq0
 y8Lj8xH2zlTINqHufSvqit8L4yMBnx3Pn2VLRfFZwZtLKdrd5sHtCNl3WamOhHd8MU9r
 awvPuyOPdZe0rILA+M4qS6FTeTr3fehqrTZ0tDnOG+l+Dwtbi/ZueXeuBk/v/dwWsEOG ng== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty3ufgemq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 13:33:51 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39PCFqkJ012362;
        Wed, 25 Oct 2023 13:33:44 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvup1xcgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 13:33:44 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39PDXggA22676112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 13:33:43 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA6582004B;
        Wed, 25 Oct 2023 13:33:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B29D62004D;
        Wed, 25 Oct 2023 13:33:42 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.40.191])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Oct 2023 13:33:42 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qve10-00ASQa-0R;
        Wed, 25 Oct 2023 15:33:42 +0200
Date:   Wed, 25 Oct 2023 15:33:42 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 02/10] scsi: Use Scsi_Host and channel number as argument
 for eh_bus_reset_handler()
Message-ID: <20231025133342.GE1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-3-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231023092837.33786-3-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zwHS2W-JQT1_JuYt1gfr_SNLWChTRxjN
X-Proofpoint-GUID: zwHS2W-JQT1_JuYt1gfr_SNLWChTRxjN
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_02,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310250117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 11:28:29AM +0200, Hannes Reinecke wrote:
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 96983bb1cc45..43083efc554b 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -741,7 +741,8 @@ Details::
>  
>      /**
>      *      eh_bus_reset_handler - issue SCSI bus reset
> -    *      @scp: SCSI bus that contains this device should be reset
> +    *      @host: SCSI Host that contains the channel which should be reset
> +    *      @channel: channel to be reset
>      *
>      *      Returns SUCCESS if command aborted else FAILED

Same as in Patch 1. Although I don't know how relevant FAST_IO_FAIL is for bus
reset, we don't implement that for zFCP.

>      *
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 77c91a405d20..ee8bb7985d09 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -863,21 +863,21 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
>   * Reset the SCSI bus.
>   */
>  static int
> -ahd_linux_bus_reset(struct scsi_cmnd *cmd)
> +ahd_linux_bus_reset(struct Scsi_Host *shost, unsigned int channel)
>  {
>  	struct ahd_softc *ahd;
>  	int    found;
>  	unsigned long flags;
>  
> -	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
> +	ahd = *(struct ahd_softc **)shost->hostdata;

Not `shost_priv(shost)`? The pointer casts end up at `struct ahd_softc *`, so
`void *` as return type should be fine.

>  #ifdef AHD_DEBUG
>  	if ((ahd_debug & AHD_SHOW_RECOVERY) != 0)
> -		printk("%s: Bus reset called for cmd %p\n",
> -		       ahd_name(ahd), cmd);
> +		printk("%s: Bus reset called for channel %c\n",
> +		       ahd_name(ahd), channel + 'A');
>  #endif
>  	ahd_lock(ahd, &flags);
>  
> -	found = ahd_reset_channel(ahd, scmd_channel(cmd) + 'A',
> +	found = ahd_reset_channel(ahd, channel + 'A',
>  				  /*initiate reset*/TRUE);
>  	ahd_unlock(ahd, &flags);
>  
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index 4ae0a1c4d374..0570f2e67fad 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -753,16 +753,16 @@ ahc_linux_dev_reset(struct scsi_cmnd *cmd)
>   * Reset the SCSI bus.
>   */
>  static int
> -ahc_linux_bus_reset(struct scsi_cmnd *cmd)
> +ahc_linux_bus_reset(struct Scsi_Host *shost, unsigned int channel)
>  {
>  	struct ahc_softc *ahc;
>  	int    found;
>  	unsigned long flags;
>  
> -	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
> +	ahc = *(struct ahc_softc **)shost->hostdata;

...

>  
>  	ahc_lock(ahc, &flags);
> -	found = ahc_reset_channel(ahc, scmd_channel(cmd) + 'A',
> +	found = ahc_reset_channel(ahc, channel + 'A',
>  				  /*initiate reset*/TRUE);
>  	ahc_unlock(ahc, &flags);
>  

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
