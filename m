From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [dm-devel] [PATCH 2/2] multipath-tools: Generalizing the vpd
 0x83 processing with correct buffer length
Date: Wed, 22 Feb 2012 22:46:28 +0100
Message-ID: <1329947188.30845.0.camel@lapoo.opensvc.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B018223@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: christophe.varoqui@opensvc.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48622 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2BVVqd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 16:46:33 -0500
Received: by wgbdt10 with SMTP id dt10so443527wgb.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 13:46:31 -0800 (PST)
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B018223@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On mer., 2012-02-22 at 18:09 +0000, Moger, Babu wrote:
> Right now the buffer length for inquiry vpd 0x83 is hardcoded to 128 bytes.
> This can cause problems if the length of all the designation descriptors 
> exceed 128 bytes. This was causing me issues while configuring my storage
> with alua. I have generalized the processing with correct buffer length.
> Patch has been tested with NetApp E-series storage.
> 
Both patches applied.
Thanks.

> Signed-off-by: Babu Moger <babu.moger@netapp.com>
> ---
> --- multipath-tools/libmultipath/prioritizers/alua_rtpg.c.orig	2012-02-21 17:16:06.000000000 -0600
> +++ multipath-tools/libmultipath/prioritizers/alua_rtpg.c	2012-02-21 17:20:06.000000000 -0600
> @@ -172,38 +172,62 @@ get_target_port_group_support(int fd)
>  int
>  get_target_port_group(int fd)
>  {
> -	unsigned char		buf[128];
> +	unsigned char		*buf;
>  	struct vpd83_data *	vpd83;
>  	struct vpd83_dscr *	dscr;
>  	int			rc;
> +	int			buflen, scsi_buflen;
>  
> -	memset(buf, 0, sizeof(buf));
> -	rc = do_inquiry(fd, 1, 0x83, buf, sizeof(buf));
> -	if (!rc) {
> -		vpd83 = (struct vpd83_data *) buf;
> -
> -		rc = -RTPG_NO_TPG_IDENTIFIER;
> -		FOR_EACH_VPD83_DSCR(vpd83, dscr) {
> -			if (vpd83_dscr_istype(dscr, IDTYPE_TARGET_PORT_GROUP)) {
> -				struct vpd83_tpg_dscr *	p;
> -
> -				if (rc != -RTPG_NO_TPG_IDENTIFIER) {
> -					PRINT_DEBUG("get_target_port_group: "
> -						"more than one TPG identifier "
> -						"found!\n");
> -					continue;
> -				}
> +	buflen = 128; /* Lets start from 128 */
> +	buf = (unsigned char *)malloc(buflen);
> +	if (!buf) {
> +		PRINT_DEBUG("malloc failed: could not allocate"
> +			     "%u bytes\n", buflen);
> +		return -RTPG_RTPG_FAILED;
> +	}
>  
> -				p  = (struct vpd83_tpg_dscr *) dscr->data;
> -				rc = get_uint16(p->tpg);
> -			}
> +	memset(buf, 0, buflen);
> +	rc = do_inquiry(fd, 1, 0x83, buf, buflen);
> +	if (rc < 0)
> +		goto out;
> +
> +	scsi_buflen = (buf[2] << 8 | buf[3]) + 4;
> +	if (buflen < scsi_buflen) {
> +		free(buf);
> +		buf = (unsigned char *)malloc(scsi_buflen);
> +		if (!buf) {
> +			PRINT_DEBUG("malloc failed: could not allocate"
> +				     "%u bytes\n", scsi_buflen);
> +			return -RTPG_RTPG_FAILED;
>  		}
> -		if (rc == -RTPG_NO_TPG_IDENTIFIER) {
> -			PRINT_DEBUG("get_target_port_group: "
> -				"no TPG identifier found!\n");
> +		buflen = scsi_buflen;
> +		memset(buf, 0, buflen);
> +		rc = do_inquiry(fd, 1, 0x83, buf, buflen);
> +		if (rc < 0)
> +			goto out;
> +	}
> +
> +	vpd83 = (struct vpd83_data *) buf;
> +	rc = -RTPG_NO_TPG_IDENTIFIER;
> +	FOR_EACH_VPD83_DSCR(vpd83, dscr) {
> +		if (vpd83_dscr_istype(dscr, IDTYPE_TARGET_PORT_GROUP)) {
> +			struct vpd83_tpg_dscr *p;
> +			if (rc != -RTPG_NO_TPG_IDENTIFIER) {
> +				PRINT_DEBUG("get_target_port_group: more "
> +					    "than one TPG identifier found!\n");
> +				continue;
> +			}
> +			p  = (struct vpd83_tpg_dscr *)dscr->data;
> +			rc = get_uint16(p->tpg);
>  		}
>  	}
>  
> +	if (rc == -RTPG_NO_TPG_IDENTIFIER) {
> +		PRINT_DEBUG("get_target_port_group: "
> +			    "no TPG identifier found!\n");
> +	}
> +out:
> +	free(buf);
>  	return rc;
>  }
>  
> 
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel



