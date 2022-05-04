Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74C0C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 11:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348871AbiEDLhi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 07:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243688AbiEDLhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 07:37:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D791AF10
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 04:34:00 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244BQxxl012808;
        Wed, 4 May 2022 11:33:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ZDGFh7svGPcP526v3YnyYIM3kRH+Se6prkAChaCCn8E=;
 b=flUraAVts1yBhq0CrpSshoGh5x4hEU3Bja015al2iFG2bnvWVa3r428kxp5VpkQhVY+4
 MuQZMhAT7EZOC6MMPu66aTM2NmvyCZ4aI8J/cV4NUqk/DPN8ObnKMNZkWe0VvxogTTI1
 8JzLsCMm+Rjilgt6dEkm9zVTTWARCb5lRauK23ghM2bYomH2/8hc+MELZsKwByPpZWPt
 l4glzRtTkajfh2dLNRwKNany5INrDbRsB4CDH/aw0DwAqVtorPuNK1Q1XOwYG9j7F4Jp
 SXNtU5ADN4G0LyKRWNLDA6xxfYHX3qNtcjeGbCi4Ai2DDAuAuei7elu/PhZM8oi4+qlf ZA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3furmfg4gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:33:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 244BR8mX024536;
        Wed, 4 May 2022 11:33:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ftp7ftcvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:33:50 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 244BXmOP56295828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 11:33:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0746211C054;
        Wed,  4 May 2022 11:33:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E95EA11C052;
        Wed,  4 May 2022 11:33:47 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.86.219])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  4 May 2022 11:33:47 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1nmDGN-000wxC-CZ; Wed, 04 May 2022 13:33:47 +0200
Date:   Wed, 4 May 2022 11:33:47 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 03/24] zfcp: open-code fc_block_scsi_eh() for host reset
Message-ID: <YnJkmzzIdW8BvT4+@t480-pf1aa2c2>
References: <20220503200704.88003-1-hare@suse.de>
 <20220503200704.88003-4-hare@suse.de>
 <YnJdEio0ifb9/McS@t480-pf1aa2c2>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <YnJdEio0ifb9/McS@t480-pf1aa2c2>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 91QRhISgrfWqtN2wI_CR2mZScw6rtei3
X-Proofpoint-GUID: 91QRhISgrfWqtN2wI_CR2mZScw6rtei3
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_03,2022-05-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040076
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 04, 2022 at 11:01:38AM +0000, Benjamin Block wrote:
> On Tue, May 03, 2022 at 10:06:43PM +0200, Hannes Reinecke wrote:
> > +	list_for_each_entry(port, &adapter->port_list, list) {
> > +		struct fc_rport *rport = port->rport;
> 
> Like Steffen said in the other review, this may be NULL here, since
> `scpnt` can be from a different context, and there is no guarantees this
> is always assigned, if you iterate over all port of an adapter.
> 
> So you want:
> 
>     if (!rport)
>             continue;

That is probably wrong; see Steffen's comments w.r.t. waiting for them
to appear, instead of skipping them.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
