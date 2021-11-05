Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104FAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 11:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E119160240
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 11:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhKEL2F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 07:28:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59686 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229722AbhKEL2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 07:28:04 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5999XO031244;
        Fri, 5 Nov 2021 11:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=e9D2hDXw5uLaWjr0O62LR56g3ZNMoC7f4LEvQFXitpE=;
 b=nZon3T3iRBmS8xONrD1Te57byAh7Y88nL/8P11ViB+jHfxvjU4PW6FjuHJZ/E2nVFxzS
 rgsoFV6QLxIimPtJZuzUBmsoGYlc18j2P99+VVAOG/0LhwmvPbj3u+1gJAXSk5X3L+DP
 x2b0KpHMTrQn8SOGvH1MZSbTFRlExj24TPw1/4VPkm3/O5rMmUrGqWq+Rlbmafk66mpG
 +qUDhfQb8aVk85CqXN17SzhcqGxUl4/mqaRy1gwI1hL0KQ0reHZ5BgstuIydnCNzBSpa
 bwD+SWmzJ3ynRvtQaSbxHQIEbETBreQxySEGPrNGQCqnqgH3dTjXGIT818fteV71cTFE IA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4xruwu71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 11:24:19 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A5BDTOs014179;
        Fri, 5 Nov 2021 11:24:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3c4t4fkkdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 11:24:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A5BHiIE52101476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Nov 2021 11:17:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A1DF4C04E;
        Fri,  5 Nov 2021 11:24:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3D2B4C050;
        Fri,  5 Nov 2021 11:24:13 +0000 (GMT)
Received: from [9.145.172.52] (unknown [9.145.172.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Nov 2021 11:24:13 +0000 (GMT)
Message-ID: <22139a80-3f64-1f21-6b5c-65d250bafe09@linux.ibm.com>
Date:   Fri, 5 Nov 2021 12:24:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH][next] scsi: Replace one-element arrays with
 flexible-array members
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Neerav Parikh <neerav.parikh@intel.com>,
        Ross Brattain <ross.b.brattain@intel.com>,
        Robert Love <robert.w.love@intel.com>
References: <20211105091102.GA126301@embeddedor>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20211105091102.GA126301@embeddedor>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H5tiez4w19d-7XeK4JdROvAkqqT6Gkj0
X-Proofpoint-ORIG-GUID: H5tiez4w19d-7XeK4JdROvAkqqT6Gkj0
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_01,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 phishscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050065
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/21 10:11, Gustavo A. R. Silva wrote:
> Use flexible-array members in struct fc_fdmi_attr_entry and
> fs_fdmi_attrs instead of one-element arrays, and refactor the
> code accordingly.
> 
> Also, turn the one-element array _port_ in struct fc_fdmi_rpl
> into a simple object of type struct fc_fdmi_port_name, as it
> seems there is no more than just one port expected:
> 
> $ git grep -nw numport drivers/scsi/
> drivers/scsi/csiostor/csio_lnode.c:447: reg_pl->numport = htonl(1);
> drivers/scsi/libfc/fc_encode.h:232:             put_unaligned_be32(1, &ct->payload.rhba.port.numport);
> 
> Also, this helps with the ongoing efforts to globally enable
> -Warray-bounds and get us closer to being able to tighten the
> FORTIFY_SOURCE routines on memcpy().
> 
> https://github.com/KSPP/linux/issues/79
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/scsi/csiostor/csio_lnode.c | 2 +-
>   drivers/scsi/libfc/fc_encode.h     | 4 ++--
>   include/scsi/fc/fc_ms.h            | 6 +++---
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
> index d5ac93897023..cf9dd79ee488 100644
> --- a/drivers/scsi/csiostor/csio_lnode.c
> +++ b/drivers/scsi/csiostor/csio_lnode.c
> @@ -445,7 +445,7 @@ csio_ln_fdmi_dprt_cbfn(struct csio_hw *hw, struct csio_ioreq *fdmi_req)
>   	/* Register one port per hba */
>   	reg_pl = (struct fc_fdmi_rpl *)pld;
>   	reg_pl->numport = htonl(1);
> -	memcpy(&reg_pl->port[0].portname, csio_ln_wwpn(ln), 8);
> +	memcpy(&reg_pl->port.portname, csio_ln_wwpn(ln), 8);
>   	pld += sizeof(*reg_pl);
> 
>   	/* Start appending HBA attributes hba */
> diff --git a/drivers/scsi/libfc/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
> index 74ae7fd15d8d..5806f99e4061 100644
> --- a/drivers/scsi/libfc/fc_encode.h
> +++ b/drivers/scsi/libfc/fc_encode.h
> @@ -232,7 +232,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
>   		put_unaligned_be32(1, &ct->payload.rhba.port.numport);
>   		/* Port Name */
>   		put_unaligned_be64(lport->wwpn,
> -				   &ct->payload.rhba.port.port[0].portname);
> +				   &ct->payload.rhba.port.port.portname);
> 
>   		/* HBA Attributes */
>   		put_unaligned_be32(numattrs,

> diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
> index 00191695233a..44fbe84fa664 100644
> --- a/include/scsi/fc/fc_ms.h
> +++ b/include/scsi/fc/fc_ms.h

> @@ -174,7 +174,7 @@ struct fs_fdmi_attrs {

/*
  * Registered Port List

>    */
>   struct fc_fdmi_rpl {
>   	__be32				numport;
> -	struct fc_fdmi_port_name	port[1];
> +	struct fc_fdmi_port_name	port;
>   } __attribute__((__packed__));

While I'm not affected by the change, it feels to me as if these are protocol 
definitions originating in a T11 Fibre Channel standard FC-GS. It's a port 
*list*. Can you "modify" the standard here?

The fact, that currently existing code users only ever seem to use one single 
port in the list, would be an independent thing to me.


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
