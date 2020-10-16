Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D403C433E7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 18:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2884420EDD
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 18:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="poIwDV7j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392065AbgJPSe6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 14:34:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391856AbgJPSew (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2020 14:34:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GIYQNc150982;
        Fri, 16 Oct 2020 18:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=I/gW8HJV9pvuLfuukvBCr/9x8Rk3MhORP3rWasgbwzg=;
 b=poIwDV7joJtD4eL/nKgkVcU0JBuUpqP/2Gw8oR/8usJ6mC1dIXNJ/MT4HiWswN1n7bga
 ktdHOLnSx+SPJauLCjHOj4Bn+YVEkWNwJTX0KcU+A2GIk4zAb5geHbJJy+kX+n91rysq
 SxMws28fmLW9Y2TfBLdtzleKar6+4msVJLJe+OFFizFXX7jGcyJ3YQ41xQnPIvZmJLsO
 NhdHK4IhkPjyzu//IDSc5mLyMmhK/V4SBS1ET3Utu/3CDpLJ0G4eDcrNOH2T9c7qRepo
 QS18TADpmjhE4eIbnIRLaxZrU1Nz0Ji3pFFe3FM2Z7plfacCrUUfxl7ZlmoqxSy14iP2 ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3434wm37b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Oct 2020 18:34:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09GIJoge019972;
        Fri, 16 Oct 2020 18:34:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 343phst676-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Oct 2020 18:34:45 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09GIYitL022597;
        Fri, 16 Oct 2020 18:34:44 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Oct 2020 11:34:43 -0700
Subject: Re: [PATCH v3 06/17] scsi_transport_fc: Added store fucntionality to
 set the rport port_state using sysfs
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-7-git-send-email-muneendra.kumar@broadcom.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <0f4c83ca-351b-1dc4-85d8-d595d2d33f31@oracle.com>
Date:   Fri, 16 Oct 2020 13:34:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1602732462-10443-7-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9776 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010160136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/14/20 10:27 PM, Muneendra wrote:
> Added a store functionality to set rport port_state using sysfs
> under  fc_remote_ports/rport-*/port_state
> 
> With this functionality the user can move the port_state from
> Marginal->Online and Online->Marginal.
> 
> On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
> scmd->state for all the io's on the scsi device associated
> with remote port.
> 
> On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with remote port.
> 
> Below is the interface provided to set the port state to Marginal
> and Online.
> 
> echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
> echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v3:
> Removed the port_state from starget attributes.
> Enabled the store functionality for port_state under remote port.
> used the starget_for_each_device to traverse around all the devices
> under rport
> 
> v2:
> Changed from a noretries_abort attribute under fc_transport/target*/ to
> port_state for changing the port_state to a marginal state
> ---
>   drivers/scsi/scsi_transport_fc.c | 85 +++++++++++++++++++++++++++++++-
>   1 file changed, 83 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index df66a51d62e6..ac5283b645a6 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -943,7 +943,88 @@ show_fc_rport_roles (struct device *dev, struct device_attribute *attr,
>   static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
>   		show_fc_rport_roles, NULL);
>   
> -fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
> +static void
> +device_chg_noretries_abort(struct scsi_device *sdev, void *data)
> +{
> +	scsi_chg_noretries_abort_io_device(sdev, *(bool *)data);
> +}
> +
> +static int
> +target_chg_noretries_abort(struct device *dev, void *data)
> +{
> +	if (scsi_is_target_device(dev))
> +		starget_for_each_device(to_scsi_target(dev), data,
> +					device_chg_noretries_abort);
> +	return 0;
> +}
> +
> +static void scsi_target_chg_noretries_abort(struct device *dev, bool set)
> +{
> +	if (scsi_is_target_device(dev))
> +		starget_for_each_device(to_scsi_target(dev), &set,
> +					device_chg_noretries_abort);
> +	else
> +		device_for_each_child(dev, &set, target_chg_noretries_abort);
> +}
> +
> +/*
> + * Sets port_state to Marginal/Online.
> + * On Marginal it Sets  no retries on abort in scmd->state for all
> + * outstanding io of all the scsi_devs
> + * This only allows ONLINE->MARGINAL and MARGINAL->ONLINE

The above comments are not needed since not counting comments the code 
is almost the same number of lines as the comments. Plus the comments 
below say the same thing. And the functions/fields/variables you are 
using below are pretty clear in what they are doing.

> + */
> +static ssize_t fc_rport_set_marginal_state(struct device *dev,
> +						struct device_attribute *attr,
> +						const char *buf, size_t count)
> +{
> +	struct fc_rport *rport = transport_class_to_rport(dev);
> +	enum fc_port_state port_state;
> +	int ret = 0;
> +
> +	ret = get_fc_port_state_match(buf, &port_state);

The kernel test robot mentioned this.

> +
> +	if (port_state == FC_PORTSTATE_MARGINAL) {
> +		/*
> +		 * Change the state to marginal only if the
> +		 * current rport state is Online
> +		 * Allow only Online->marginal
> +		 */
> +		if (rport->port_state == FC_PORTSTATE_ONLINE) {
> +			rport->port_state = port_state;
> +			scsi_target_chg_noretries_abort(&rport->dev, 1);
> +		}

Should this return a failure if port_state is not online?


> +	} else if (port_state == FC_PORTSTATE_ONLINE) {
> +		/*
> +		 * Change the state to Online only if the
> +		 * current rport state is Marginal
> +		 * Allow only  MArginal->Online
> +		 */
> +		if (rport->port_state == FC_PORTSTATE_MARGINAL) {
> +			rport->port_state = port_state;
> +			scsi_target_chg_noretries_abort(&rport->dev, 0);
> +		}

Same here.

> +	} else
> +		return -EINVAL;
> +	return count;
> +}
> +
> +static ssize_t
> +show_fc_rport_port_state(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	const char *name;
> +	struct fc_rport *rport = transport_class_to_rport(dev);
> +
> +	name = get_fc_port_state_name(rport->port_state);
> +	if (!name)
> +		return -EINVAL;
> +
> +	return snprintf(buf, 20, "%s\n", name);
> +}
> +
> +static FC_DEVICE_ATTR(rport, port_state, 0444 | 0200,
> +			show_fc_rport_port_state, fc_rport_set_marginal_state);
> +
>   fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);
>   
>   /*
> @@ -2266,7 +2347,7 @@ fc_attach_transport(struct fc_function_template *ft)
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
> -	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
> +	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(port_state);
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
>   
> 

