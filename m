Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B6EC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 18:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C948207FD
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 18:23:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2dze/8Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbfKYSXK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 13:23:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50815 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727269AbfKYSXK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 13:23:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574706189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JNhUID+N4Q1aUynQCwE2KVqtqKFqClgwcc74Itp1nk4=;
        b=W2dze/8QFxzOwl7HsFN4WlUpHaenEttabdaxev1lko/bf+qK9OIeDJoFw+DPEOl/1PY/ov
        fEY3hwDwHZVYCaBvlmlGfe+PqVyRlhT0qjcYGdcp9QuCoTQBGu+u9oLNPrQ4S4+DWQlCEZ
        Ke9ZfROWyo5jQeCJ5JNJA5pPW62cckw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-flPJbrCTMKmEkDtHBxzwJQ-1; Mon, 25 Nov 2019 13:23:06 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39392107ACE3;
        Mon, 25 Nov 2019 18:23:05 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6310B5D6A0;
        Mon, 25 Nov 2019 18:23:04 +0000 (UTC)
Message-ID: <e1048412185b5d1d7552b0ca0b17b2d198416a08.camel@redhat.com>
Subject: Re: [PATCH] scsi: lpfc: Move work items to a stack list
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Smart <james.smart@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 25 Nov 2019 13:23:03 -0500
In-Reply-To: <d9c8974a-ba64-afb7-983c-f344d6981e9d@broadcom.com>
References: <20191105080855.16881-1-dwagner@suse.de>
         <yq1h838pivf.fsf@oracle.com>
         <20191119132854.mwkxx4fixjaoxv4w@beryllium.lan>
         <4a1fedc9-03f1-7312-fd50-a041a78c0294@broadcom.com>
         <20191119181435.taxa56wbf4zd4f2f@beryllium.lan>
         <44cc15adc190fb1f6f89cbb8478aadda35f6b1e2.camel@redhat.com>
         <d9c8974a-ba64-afb7-983c-f344d6981e9d@broadcom.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: flPJbrCTMKmEkDtHBxzwJQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-11-25 at 09:06 -0800, James Smart wrote:
> On 11/25/2019 8:40 AM, Ewan D. Milne wrote:
> > [ removed linux-kernel from cc: ]
> > 
> > We may have hit the same issue in testing, we're looking at it.
> > 
> > -Ewan
> > 
> 
> Make sure you have this patch in your testing (from 12.6.0.0 patch set):
> 
> scsi: lpfc: Fix bad ndlp ptr in xri aborted handling
> commit 324e1c402069e8d277d2a2b18ce40bde1265b96a
> 
> -- james
> 

That patch was present.

-Ewan

