Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E93ECAAD5
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Sep 2022 17:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237988AbiIERWW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Sep 2022 13:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbiIERWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Sep 2022 13:22:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28E161D98
        for <linux-scsi@vger.kernel.org>; Mon,  5 Sep 2022 10:22:16 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 285HDfKm010867;
        Mon, 5 Sep 2022 17:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=U/eXC6gE60NrCv37lnHTnjj0qY22Ns3iSRp538G7Hi8=;
 b=lcJDJLFaOnyuNwxz2nN3y8YwdnaEs3UPlRVigGo9/Si3FcfasDl1sRO6pxz/UxqyzxK+
 5b0mLqYu/sWAoPIzLfwigc39SmVwA82VAj4W7IWSRPSbrwwJOUchc2x8grvWb5P1mmEI
 oU/1vsjgcc9vvZfxpPZjXkj+mTAzZTg4Yjehj9COTyusih3JBsx6oi0eiRlbiMsTU/Cj
 Gi/mHb0Q8AjSnMGuws4H8Itwvm2uy1Pm6/35X8ey2QxI/p7zyxO7I10A86lqHbeFu81M
 smZV9YAsjjnT3GBELUcr7gv0IqwzCkkQDQ48h1y5Uee0xXr23fmlNvDQqyvbdH005Z8L AQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdnaqr5ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 17:22:06 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 285HKEAO018715;
        Mon, 5 Sep 2022 17:22:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3jbxj8t0r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Sep 2022 17:22:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 285HMQXo44040694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Sep 2022 17:22:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 969A35204F;
        Mon,  5 Sep 2022 17:22:02 +0000 (GMT)
Received: from [9.145.147.217] (unknown [9.145.147.217])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8FD555204E;
        Mon,  5 Sep 2022 17:22:01 +0000 (GMT)
Message-ID: <d192edad-26c1-c466-49d4-56e19df4c24c@linux.ibm.com>
Date:   Mon, 5 Sep 2022 19:22:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] scsi: scsi_transport_fc: use %u for dev_loss_tmo
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "George, Martin" <Martin.George@netapp.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        James Smart <james.smart@broadcom.com>
References: <20220902131519.16513-1-mwilck@suse.com>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20220902131519.16513-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aVnw9iE98B5mqhEs9Xe5H5B_9avz0sRM
X-Proofpoint-GUID: aVnw9iE98B5mqhEs9Xe5H5B_9avz0sRM
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-05_12,2022-09-05_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 bulkscore=0 priorityscore=1501 adultscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209050082
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/2/22 15:15, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> dev_loss_tmo is an unsigned value. Using "%d" as output format
> causes irritating negative values to be shown in sysfs.
> 

Yes, I had also noticed this a while ago and took the following notes along 
with the workaround clamping -1 to the old max value in my automated zfcp test 
script in user space:

read val < ${fcrportsys}/dev_loss_tmo
# 
https://github.com/opensvc/multipath-tools/commit/d01ccd33fca99884baeb7da037f729e6058c03ef
# ("libmultipath: dev_loss_tmo is unsigned") changing MAX_DEV_LOSS_TMO from 
0x7FFFFFFF==2147483647 to UINT_MAX
# on top of the older
# 
https://github.com/opensvc/multipath-tools/commit/15e5070fdc22cde2dd2a9f4a8022e124e9425bd9
# ("libmultipath: ensure dev_loss_tmo will be update to MAX_DEV_LOSS_TMO if 
no_path_retry set to queue")
# vvv
# The deamon seems to complain:
# multipathd[...]: rport-1:0-3: Cannot parse dev_loss_tmo attribute '-1'
# ^^^
[ "$val" = "-1" ] && val=2147483647


Even though I don't care too much about the default value source in fc_host, I 
wonder if we should also fix this for consistency:
> fc_private_host_show_function(dev_loss_tmo, "%d\n", 20, );
=> fc_private_host_show_function(dev_loss_tmo, "%u\n", 20, );
> static FC_DEVICE_ATTR(host, dev_loss_tmo, S_IRUGO | S_IWUSR,
> 		      show_fc_host_dev_loss_tmo,
> 		      store_fc_private_host_dev_loss_tmo);

After all, the other default value source is already a proper unsigned int:
> /*
>  * dev_loss_tmo: the default number of seconds that the FC transport
>  *   should insulate the loss of a remote port.
>  *   The maximum will be capped by the value of SCSI_DEVICE_BLOCK_MAX_TIMEOUT.
>  */
> static unsigned int fc_dev_loss_tmo = 60;		/* seconds */
> 
> module_param_named(dev_loss_tmo, fc_dev_loss_tmo, uint, S_IRUGO|S_IWUSR);
> MODULE_PARM_DESC(dev_loss_tmo,
> 		 "Maximum number of seconds that the FC transport should"
> 		 " insulate the loss of a remote port. Once this value is"
> 		 " exceeded, the scsi target is removed. Value should be"
> 		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT if"
> 		 " fast_io_fail_tmo is not set.");



Reviewed-by: Steffen Maier <maier@linux.ibm.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/scsi_transport_fc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index a2524106206db..df4aa4a5f83c4 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -1170,7 +1170,7 @@ static int fc_rport_set_dev_loss_tmo(struct fc_rport *rport,
>   	return 0;
>   }
> 
> -fc_rport_show_function(dev_loss_tmo, "%d\n", 20, )
> +fc_rport_show_function(dev_loss_tmo, "%u\n", 20, )
>   static ssize_t
>   store_fc_rport_dev_loss_tmo(struct device *dev, struct device_attribute *attr,
>   			    const char *buf, size_t count)


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
