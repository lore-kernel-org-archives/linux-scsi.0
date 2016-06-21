From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] lpfc: support for CPU phys_id and core_id on
 PowerPC64
Date: Tue, 21 Jun 2016 14:42:09 -0300
Message-ID: <57697C71.3060109@linux.vnet.ibm.com>
References: <1464813809-22066-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <201606012043.u51KflcX004680@mx0a-001b2d01.pphosted.com>
 <20160621142902.GA10597@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46140 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606AbcFURnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2016 13:43:12 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5LHcuEW012976
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 13:42:18 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23pe03v7kp-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 13:42:18 -0400
Received: from localhost
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
	Tue, 21 Jun 2016 14:42:15 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 3FB701DC006E
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 13:42:07 -0400 (EDT)
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5LHgEFg5017620
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 14:42:14 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
	by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5LHgDBd001127
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 14:42:14 -0300
In-Reply-To: <20160621142902.GA10597@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, dick.kennedy@broadcom.com, james.smart@broadcom.com

On 06/21/2016 11:29 AM, Christoph Hellwig wrote:
> I really don't think this sort of low level information has business
> in a low level driver.  I've been trying to put some infrastructure
> together to move this to the core kernel [1], and it would be good to
> help use this in more drivers.  Especially given that lpfc may use
> blk-mq which will not respect this current assignment for the queue
> mapping.

Agree.

However, this patchset targets the non blk-mq/scsi-mq usage of the
lpfc driver, which falls back to CPU-number/queue-number mapping.

This turns out to still be the case w/ some distros where ppc64/le
usually runs, on which it would be easier to adapt this relatively
small change than moving forward w/ blk-mq/scsi-mq, for example --
even if the latter is clearly a superior approach.

> [1] http://lists.infradead.org/pipermail/linux-nvme/2016-June/005012.html


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center

