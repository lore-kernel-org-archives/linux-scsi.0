Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A193CC4727D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6086420781
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:42:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AgmLnBvm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgJEImG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:42:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbgJEImF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:42:05 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0958WFeh010582;
        Mon, 5 Oct 2020 04:42:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=xl64wpUGFigTnKwAQGhumIVfWLygp47tLUWZU3rBCRk=;
 b=AgmLnBvm4A2ni+8sBhKcilVZsqCT/Oj28Y4Y8CLvdbVK/ZmobSVkxTrNuH9pF4KOkMv7
 D0ecGgncys3gsmVwckPrIwKgUImYJs8uEXIfMYcn9w8wvAcrefwanUtE6kMhYdhiZSS2
 5B9v3ciPlVZjtMBz6pouWU+ml+F7NOJjvkR4Fd7OXCr83lb62UisYj+j8wMhcEj1+sEI
 Heg2TCjHNGuaTo6xEfKzxrqTb8NMvGdEIbBn/M6caGGPCPcEGC86hJ+j1rFItNzUSJPs
 fLTrFggBqwZF1n/hD8wA330cKrsq287NmDWEGhne74jLo+AaYEraJuE7+9SkCfURDc0N Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33yysg0twc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 04:42:01 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0958WEag010544;
        Mon, 5 Oct 2020 04:42:01 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33yysg0tu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 04:42:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0958d5hk018302;
        Mon, 5 Oct 2020 08:41:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 33xgjh1y4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Oct 2020 08:41:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0958fuZQ31588834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Oct 2020 08:41:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C2E942041;
        Mon,  5 Oct 2020 08:41:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09B874203F;
        Mon,  5 Oct 2020 08:41:56 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.23.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  5 Oct 2020 08:41:55 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kPM4B-000AdS-0m; Mon, 05 Oct 2020 10:41:55 +0200
Date:   Mon, 5 Oct 2020 10:41:53 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH v2 7/8] scsi_transport_fc: Added a new sysfs attribute
 port_state
Message-ID: <20201005084153.GB8365@t480-pf1aa2c2>
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-8-git-send-email-muneendra.kumar@broadcom.com>
 <20201002162633.GA8365@t480-pf1aa2c2>
 <ca995d96-608b-39b9-8ded-4a6dd7598660@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca995d96-608b-39b9-8ded-4a6dd7598660@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_06:2020-10-02,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050060
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 05, 2020 at 08:49:27AM +0200, Hannes Reinecke wrote:
> On 10/2/20 6:26 PM, Benjamin Block wrote:
> > On Mon, Sep 28, 2020 at 10:20:56AM +0530, Muneendra wrote:
> > > Added a new sysfs attribute port_state under fc_transport/target*/
> > > 
> > > With this new interface the user can move the port_state from
> > > Marginal -> Online and Online->Marginal.
> > > 
> > > On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
> > > scmd->state for all the pending io's on the scsi device associated
> > > with target port.
> > > 
> > > On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
> > > scmd->state for all the pending io's on the scsi device associated
> > > with target port.
> > > 
> > > Below is the interface provided to set the port state to Marginal
> > > and Online.
> > > 
> > > echo "Marginal" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state
> > > echo "Online" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state
> > > 
> > > Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
> > > fc_timeout_deleted_rport functions  to handle the new rport state
> > > FC_PORTSTATE_MARGINAL.
> > 
> > Hey Muneendra, out of curiosity, what drives these changes to the
> > port_state in userspace, and based on what?
> > 
> > I imagine something uses the other bunch of sysfs attributes that were
> > introduced recently that get feed by FPIN notifications about congestion
> > and such, or?
> > 
> > If so, is there any plans to integrated something along the lines in
> > multipathd/multipath-tools? Or maybe I missed that.
> > 
>
> My idea here was that that 'marginal' port state is initiated by FPIN
> notifications; ideally set from the driver itself, but initially most likely
> from userspace (eg multipathd).
> 
> Problem here is that the FPIN comes in various flavours (eg congestion or
> link degradation), each of which will result in either one or several FPIN
> notifications.
> EG for link congestion it is expected to get messages at a certain frequency
> for as long as the situation occurs.
> Meaning we would have to have some sort of mechanism for checking that
> frequency, and reset the state if the condition persists.

Yeah, that makes sense.

> 
> How exactly we're going to do this, whether by external daemon or integrated
> into multipathd, is currently subject for debate and testing.
> I would prefer to have it integrated into multipathd, but it might well
> become too complex such that an external daemon might be the better option.
> 

Less "moving parts" would be great. A proper FC setup with multipath is
already a burden on many users, yet an other daemon to juggle with and
coordinate adds more to that. But I'm not doing the work rn so that's
not my choice :)

Thanks for the explanation Hannes.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
