Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8843C7EE22
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 08:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjEDIwr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 04:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjEDIwp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 04:52:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC8DE45;
        Thu,  4 May 2023 01:52:43 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3448gHGb032124;
        Thu, 4 May 2023 08:52:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ZTnS9zSi9xMln0tCtfiJ5m54kyrZ+iA3FnOsDmLRquY=;
 b=IyyVIYuvni1HatuukFEhWhVAJyeDCzRZHx1MeFd/BBdsV+CxyO8ARiQLf11DqMXUA+Oc
 zbQnQPbVT60zXUtwjagH3eFXzFhL++4FPQm4WPhBhtK82oCK2tf42Qiu1CyV0gl8TRoX
 kkarpTElQrIWRMsFg/6YQPnav49jCSmzcKlhHsGYhsLL+4CqySxZQouncaqnzm1kI1Zn
 vXdvUVvmWZnvIJ3MIXXeAgFcdS61Nf/2FRiFiQAMAENeDmjdZgdShykMUv0TTdZspCfR
 b92URBPCMWXTLTBZlosCIzfZowoVLtB/R1mQZ34/U1oP/G4wVzMYbHQlgrFFupFxjujv JA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qc9e5r9qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 08:52:31 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3442enYS027174;
        Thu, 4 May 2023 08:52:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6j8x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 08:52:29 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3448qQX927918772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 May 2023 08:52:26 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B539B20040;
        Thu,  4 May 2023 08:52:26 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A15A220043;
        Thu,  4 May 2023 08:52:26 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.144])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  4 May 2023 08:52:26 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1puUhO-006fPR-0m;
        Thu, 04 May 2023 10:52:26 +0200
Date:   Thu, 4 May 2023 08:52:26 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Oliver Neukum <oneukum@suse.com>, Hannes Reinecke <hare@suse.de>,
        Maxime Bizon <mbizon@freebox.fr>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Reproducible deadlock when usb-storage scsi command timeouts
 twice
Message-ID: <20230504085226.GC1032383@t480-pf1aa2c2.fritz.box>
References: <ZEllnjMKT8ulZbJh@sakura>
 <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
 <20230503102440.GL18384@t480-pf1aa2c2.fritz.box>
 <941e8420-f99f-5832-2ea9-3ba5eca545ad@suse.com>
 <20230503125137.GA1032383@t480-pf1aa2c2.fritz.box>
 <d25bfa50-b5a0-bd0e-fd14-94967e374033@suse.com>
 <97a67f78-4888-4fe7-9bfc-87d0bb6cc8b2@rowland.harvard.edu>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <97a67f78-4888-4fe7-9bfc-87d0bb6cc8b2@rowland.harvard.edu>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gwKcH8SzySWeuYUR-_XXWwEovfqhImqn
X-Proofpoint-GUID: gwKcH8SzySWeuYUR-_XXWwEovfqhImqn
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_05,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 spamscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=870 suspectscore=0 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040069
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 03, 2023 at 10:25:10AM -0400, Alan Stern wrote:
> On Wed, May 03, 2023 at 03:54:45PM +0200, Oliver Neukum wrote:
> > For the device a reset presumably does wipe out the command currently
> > under execution. The problem is within the driver. It thinks that
> > a command is still active. And we are limited to one command at a time
> > (on the whole bus - again protocol limitation)
> > 
> > > On random thought I had: in theory you could implement your own EH
> > > strategy handler if the default one doesn't work for you. ATA and SAS do so.
> > > [drivers/scsi/scsi_error.c:2285 `shost->transportt->eh_strategy_handler()`]
> > > This can re-use parts/all of the existing escalation sequence in
> > > `scsi_eh_ready_devs()`.
> > > 
> > > But that's no short-term fix.
> > 
> > That looks like using a sledge hammer.
> 
> I think the best answer is to accept the patch that started this email 
> thread, perhaps with a minor change.  The driver can easily abort the 
> currently running command (if any) on its own before starting a reset.

I don't think we would add an other layer of aborts in front of
device/LUN reset for all SCSI targets. That's just overkill for - it
seems - everything but USB storage, and would slow down error recovery
considerable in some cases.

If this is supposed to be done in the SCSI ML, it would have to be a
quirk/option IMO.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
