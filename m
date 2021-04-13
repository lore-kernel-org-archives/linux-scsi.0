Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE77C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 14:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A017261353
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 14:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbhDMOFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 10:05:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15870 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231741AbhDMOE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Apr 2021 10:04:56 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DE3ETf001980;
        Tue, 13 Apr 2021 10:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=0TCW3Wq3rrOuY996NsEGn4PZRWFdDjYxricsSie+yX8=;
 b=bbSc6yXy7iBXWM0Mf6eEOk8zocFFTv+a5tlCZ4E/j1eLtitfhr7u9IYAJkXQGbmOwh7Z
 C1TqBUhfIv+5sSuGcxWhvfKOpz8820bjUxtBr2J6bo0lSVE9gODChWgTU4dXDUsoRTBv
 eC5GL3X53ZsMjY+G8o0QU7mLEzCWp3ozqePoe8wpbe4v9mw2PjlJhirxr4KszfQoAVp9
 o/Ae0X0sC3M6C/EJdAuTQ5dLtYH7pxF/oomDxS2qmoOlYxTt0gzAq13q72pctedHlVNX
 iZItkDIm7f/ocXpjqY1k0SqIshlvIAqMt7xnTkEj9x0k42+KJZEBFZ81NIQxTHzHvVBV ig== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vjtuc8b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 10:04:18 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13DDwCfG031110;
        Tue, 13 Apr 2021 14:04:17 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 37u3n9qfkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:04:16 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13DE4FUb28115412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 14:04:15 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CA8578060;
        Tue, 13 Apr 2021 14:04:15 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 697ED7805E;
        Tue, 13 Apr 2021 14:04:13 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.203.222])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 14:04:13 +0000 (GMT)
Message-ID: <94bff1bedd0dfa957822a6a303b48eca787f9a21.camel@linux.ibm.com>
Subject: Re: [PATCH][next] scsi: aacraid: Replace one-element array with
 flexible-array member
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Date:   Tue, 13 Apr 2021 07:04:11 -0700
In-Reply-To: <aba7d5cb-79be-088d-d1f8-9309109e9afc@embeddedor.com>
References: <20210304203822.GA102218@embeddedor>
         <202104071216.5BEA350@keescook> <yq1h7ka7q68.fsf@ca-mkp.ca.oracle.com>
         <aba7d5cb-79be-088d-d1f8-9309109e9afc@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m4eW0zKaL4oCMKfm2lypRtMb5Z_eUbje
X-Proofpoint-ORIG-GUID: m4eW0zKaL4oCMKfm2lypRtMb5Z_eUbje
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_07:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxscore=0 mlxlogscore=853 clxscore=1011 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-04-13 at 00:45 -0500, Gustavo A. R. Silva wrote:
> Hi Martin,
> 
> On 4/12/21 23:52, Martin K. Petersen wrote:
> 
> > Silencing analyzer warnings shouldn't be done at the expense of
> > human
> > readers. If it is imperative to switch to flex_array_size() to
> > quiesce
> > checker warnings, please add a comment in the code explaining that
> > the
> > size evaluates to nseg_new-1 sge_ieee1212 structs.
> 
> Done:
> 	
> https://lore.kernel.org/lkml/20210413054032.GA276102@embeddedor/

I think the reason everyone gets confused is that they think the first
argument should do something.  If flex_array_size had been defined

#define flex_array_size(p, count)			\
	array_size(count,				\
		    sizeof(*(p)) + __must_be_array(p))

Then we could have used

flex_array_size(sge, nseg_new - 1)

or

flex_array_size(rio->sge, nseg_new - 1)

and everyone would have understood either expression.  This would also
have been useful, as the first example demonstrates, when we have a
pointer rather than a flexible member ... although that means the macro
likely needs a new name.

However, perhaps just do

array_size(nseg_new - 1, sizeof(*sge));

And lose the comment?

James


