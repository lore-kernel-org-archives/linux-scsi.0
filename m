Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54901C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 09:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BA7B61059
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 09:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhDVJ3o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 05:29:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59528 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230285AbhDVJ3o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 05:29:44 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M94TWx003221;
        Thu, 22 Apr 2021 05:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1JbWzdjefGN7j20B212xQP5JZi21xzHeI+2btflqab4=;
 b=WFkq3n9APitCPuva54jPcTYCmnePWaaMVJgYzRQrmHEh1G27IjHWWLtVKeOql14RXnJC
 Qr6DU4xdA5D8mpnSS1HuLRNw+BdyGyeh/CLMjrTd+FZiNqCQzsbzfXJAsWGA+nhT4Jx9
 1IvTFngZo+IT+0P5yyVZh2pUS7wydrzwpKnHQLZcSWAWB3R8QKzoczX/71B7wdUOQ2Ec
 Zon6ND/3l/61/eaoJ/wTHzP9lqoMuwRF1P1uXZgnQNPsVyhea+oGKhTZdnoxUF2Hwkf3
 c8Owd5gvUTaEwCe+IusFZtIqnM2XnYg0xP8Wik0lezM4UZDJDUgSMoNZKvrSV6ahhnvz Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3835xxh2wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 05:28:58 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13M9QbHL094162;
        Thu, 22 Apr 2021 05:28:57 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3835xxh2vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 05:28:57 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13M9SSSN002294;
        Thu, 22 Apr 2021 09:28:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 37ypxh9hgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 09:28:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13M9Sq6o33751446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 09:28:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 630EEAE04D;
        Thu, 22 Apr 2021 09:28:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F99CAE045;
        Thu, 22 Apr 2021 09:28:52 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.88.229])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 22 Apr 2021 09:28:52 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lZVdj-003dTV-Nv; Thu, 22 Apr 2021 11:28:51 +0200
Date:   Thu, 22 Apr 2021 11:28:51 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     James Smart <jsmart2021@gmail.com>
Cc:     Muneendra <muneendra.kumar@broadcom.com>, hare@suse.de,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, emilne@redhat.com,
        mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH v9 07/13] lpfc: vmid: Implements ELS commands for appid
 patch
Message-ID: <YIFB03mLWw+kwNmS@t480-pf1aa2c2.linux.ibm.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
 <1617750397-26466-8-git-send-email-muneendra.kumar@broadcom.com>
 <YH7LPd8c4PZa1qFC@t480-pf1aa2c2.linux.ibm.com>
 <d9d57857-83f5-9ff7-a427-0817d37f5f84@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <d9d57857-83f5-9ff7-a427-0817d37f5f84@gmail.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dd4WCXQNUVMu7dc2I3PMVWH1kjJ0BYpp
X-Proofpoint-ORIG-GUID: vGnu596I2-D4GZlAZJx2yQqbIsamp9_O
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_01:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220076
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 21, 2021 at 03:55:15PM -0700, James Smart wrote:
> On 4/20/2021 5:38 AM, Benjamin Block wrote:
> ...
> > > +	len = *((u32 *)(pcmd + 4));
> > > +	len = be32_to_cpu(len);
> > > +	memcpy(vport->qfpa_res, pcmd, len + 8);
> > > +	len = len / LPFC_PRIORITY_RANGE_DESC_SIZE;
> > > +
> > > +	desc = (struct priority_range_desc *)(pcmd + 8);
> > > +	vmid_range = vport->vmid_priority.vmid_range;
> > > +	if (!vmid_range) {
> > > +		vmid_range = kcalloc(MAX_PRIORITY_DESC, sizeof(*vmid_range),
> > > +				     GFP_KERNEL);
> > > +		if (!vmid_range) {
> > > +			kfree(vport->qfpa_res);
> > > +			goto out;
> > > +		}
> > > +		vport->vmid_priority.vmid_range = vmid_range;
> > > +	}
> > > +	vport->vmid_priority.num_descriptors = len;
> > > +
> > > +	for (i = 0; i < len; i++, vmid_range++, desc++) {
> > > +		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_ELS,
> > > +				 "6539 vmid values low=%d, high=%d, qos=%d, "
> > > +				 "local ve id=%d\n", desc->lo_range,
> > > +				 desc->hi_range, desc->qos_priority,
> > > +				 desc->local_ve_id);
> > > +
> > > +		vmid_range->low = desc->lo_range << 1;
> > > +		if (desc->local_ve_id == QFPA_ODD_ONLY)
> > > +			vmid_range->low++;
> > > +		if (desc->qos_priority)
> > > +			vport->vmid_flag |= LPFC_VMID_QOS_ENABLED;
> > > +		vmid_range->qos = desc->qos_priority;
> > 
> > I'm curios, if the FC-switch signals it supports QoS for a range here, how
> > exactly interacts this with the VM IDs that you seem to allocate
> > dynamically during runtime for cgroups that request specific App IDs?
> > You don't seem to use `LPFC_VMID_QOS_ENABLED` anywhere else in the
> > series. >
> > Would different cgroups get different QoS classes/guarantees depending
> > on the selected VM ID (higher VM ID gets better QoS class, or something
> > like that?)? Would the tagged traffic be handled differently than the
> > ordinary traffic in the fabric?
> 
> The simple answer is there is no interaction w/ the cgroup on priority.
> And no- we really don't look or use it.  The ranges don't really have hard
> priority values. The way it works is that all values within a range is
> equal; a value in the first range is "higher priority" than a value in the
> second range; and a value in the second range is higher than those in the
> third range, and so on. 

Ah. That's interesting. I thought it is like that, but wasn't sure from
the spec. Thanks for clarifying.

> Doesn't really matter whether the range was marked
> Best Effort or H/M/L. There's no real "weight".
> 
> What you see is the driver simply recording the different ranges so that it
> knows what to allocate from later on. The driver creates a flat bitmap of
> all possible values (max of 255) from all ranges - then will allocate values
> on a first bit set basis.  I know at one point we were going to only
> auto-assign if there was 1 range, and if multiple range was going to defer a
> mgmt authority to tell us which range, but this obviously doesn't do that.

I was worrying a bit whether this would create some hard to debug
problems in the wild, when QoS essentially depends on the order in which
Applications/Containers are started and get IDs assigned accordingly -
assuming there is multiple priority ranges.

> Also... although this is coded to support the full breadth of what the
> standard allows, it may well be the switch only implements 1 range in
> practice.
> 

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
