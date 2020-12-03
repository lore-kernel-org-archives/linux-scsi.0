Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12231C4361B
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 16:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8339206B9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 16:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgLCQeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:34:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49502 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgLCQeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 11:34:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3GP4O0066755;
        Thu, 3 Dec 2020 16:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=rucWY9Ilx7AeHMfXjLFhV5z8jmNYBcx96keWi1kCYbo=;
 b=TyyYHCXivZdazpJ5N7A7aeeHVtj1leXJ/R2ZTYmcZV+ePgoTU7JsAQkVTu1v0kB+NZCy
 a9MNdnIEOmmKKC62jS+IbGfyCWaT+g5+Nj2Sf5DgU7/75/9UJe+kVfhXjqU+F4+1qh6k
 d6bJM0LFfubgFRJWkrwG1ftoeIMxOTAtmKG5J41yNC4z/mAxOJeVJALt3aypLW4hRNAm
 23D46/l5Acahj9wwBhcdRS1G9LIo41q1y4xp4N7bGbwEKesVKBwrJtuMhvbtEjOWMc73
 ZjjORTGOjcB+JlB05kH0na0oYwYurPgToHzPCTb0C6vOXEihzIipwrVO2HzazFMT40iI Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2b71es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 16:33:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3GUFUC017252;
        Thu, 3 Dec 2020 16:33:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540f234sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 16:33:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3GXDlB011133;
        Thu, 3 Dec 2020 16:33:18 GMT
Received: from [192.168.1.30] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 08:33:10 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 32/34] qla2xxx: fc_remote_port_chkready() returns a SCSI
 result value
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201202115249.37690-33-hare@suse.de>
Date:   Thu, 3 Dec 2020 10:33:08 -0600
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <45452920-BBA4-4ABD-8D7E-29D33DAEDD5F@oracle.com>
References: <20201202115249.37690-1-hare@suse.de>
 <20201202115249.37690-33-hare@suse.de>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 2, 2020, at 5:52 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> fc_remote_port_chkready() returns a SCSI result value, not the
> port status. So fixup the value when the remote port isn't set.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index f9c8ae9d669e..419f97467c15 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -957,7 +957,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, =
struct scsi_cmnd *cmd,
> 	srb_t *sp;
> 	int rval;
>=20
> -	rval =3D rport ? fc_remote_port_chkready(rport) : =
FC_PORTSTATE_OFFLINE;
> +	rval =3D rport ? fc_remote_port_chkready(rport) : =
(DID_NO_CONNECT << 16);
> 	if (rval) {
> 		cmd->result =3D rval;
> 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3076,
> --=20
> 2.16.4
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

