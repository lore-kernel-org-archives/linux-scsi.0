Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0FFC48BE5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 09:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B8356140C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 09:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhFOJgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 05:36:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231357AbhFOJgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 05:36:07 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15F9X94v011694;
        Tue, 15 Jun 2021 05:33:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=OcRrjH8BBH5iKsP32frZKuib2P4z3xcZZLnWSeDsCNM=;
 b=Sws/T/tGSf1TdkFSBVySt7NJr6ustvlaipx61ZU5GtEpgHP7EsmmMFaGCYIuf3r/niv8
 pSSoeLR3oxhAVp4AWngZglVJB8+I2j1UWJsnUznDhSxt58VRu4UdSsRzJdmbMhQuQU5n
 cBKU9CjNMoL5hJnAAhVz5CqH3TkAQPUqMsAPM+mE3K0Zpm6NBOiORljziViDwKTAn08r
 G00mRsopyRSxGr0HSiPHaAy8s3cz1x1j5F9FlsEEn/a20thgkltIGt+/fyT3dB0Who0a
 yUPRBnp5a3ACMgRsfadFdOkcqVG3bVHfNzWU8IVmdLFuKiWpnkR3PKXBC6bwBbuiiv6z /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 396sgrra76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 05:33:40 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15F9XCpP012020;
        Tue, 15 Jun 2021 05:33:40 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 396sgrra64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 05:33:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15F9Wx2X025013;
        Tue, 15 Jun 2021 09:33:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 394m6hsd1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 09:33:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15F9XZv324052120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 09:33:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1E9711C050;
        Tue, 15 Jun 2021 09:33:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFC0611C04C;
        Tue, 15 Jun 2021 09:33:35 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.173.127])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Jun 2021 09:33:35 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lt5Rv-001Xmy-A4; Tue, 15 Jun 2021 11:33:35 +0200
Date:   Tue, 15 Jun 2021 11:33:35 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 10/15] scsi: core: Introduce scsi_get_sector()
Message-ID: <YMhz77Vo7dAcjKoU@t480-pf1aa2c2.linux.ibm.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-11-martin.petersen@oracle.com>
 <YMdsTOpT3a4TA3E5@t480-pf1aa2c2.linux.ibm.com>
 <yq18s3bamko.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <yq18s3bamko.fsf@ca-mkp.ca.oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V3osD3bXmX4_cX-OjYNM63ult2NSSXGw
X-Proofpoint-GUID: 0YPoCbt4snnUXPCRm2En62ETOCf3ODUy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106150058
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 14, 2021 at 10:28:52PM -0400, Martin K. Petersen wrote:
> > Wondering a bit why this still uses the request pointer, after you say
> > in patch 01 that it goes away. So it should probably use
> > `blk_mq_rq_from_pdu()`?
> 
> I was just getting everything ready for Bart's series that makes this
> change throughout the tree.
> 

Ah ok, didn't realize that.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
