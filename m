Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1A6C001DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 17:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjGYR3G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 13:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjGYR3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 13:29:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF34C19B4
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 10:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690306098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AQw9Ser+M2NE25R1fRsh+0Ukg8sPQALOL3L++smDxxc=;
        b=hhv/QGVplNWhYqKITb482esoDy7+mvvOYA2wGtRB+xNUI/lzJlqyvLNSEIhMC3xm92sLw2
        /9HMhB/F7wm1qywqtPHbUTclYdZKTH0VmPuW7lxA9pSIOPTOSOTV1/PGiyshsWITuDgGBk
        lNfrDP+y5G5S422HFtaBXuWGosSpjBY=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-MUm7GKFWOkie7bp6JrBFpw-1; Tue, 25 Jul 2023 13:28:15 -0400
X-MC-Unique: MUm7GKFWOkie7bp6JrBFpw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5442438149A3;
        Tue, 25 Jul 2023 17:28:15 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.250])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8266840C2063;
        Tue, 25 Jul 2023 17:28:14 +0000 (UTC)
Date:   Tue, 25 Jul 2023 10:28:12 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: qla4xxx: Add length check when paring nlattrs
Message-ID: <ZMAGLLkaNMpy7jXS@rhel-developer-toolbox-latest>
References: <20230723080053.3714534-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230723080053.3714534-1-linma@zju.edu.cn>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jul 23, 2023 at 04:00:53PM +0800, Lin Ma wrote:
> There are three places that qla4xxx looply parses nlattrs
> * qla4xxx_set_chap_entry(...)
> * qla4xxx_iface_set_param(...)
> * qla4xxx_sysfs_ddb_set_param(...)
> and each of them directly converts the nlattr to specific pointer of
> structure without length checking. This could be dangerous as those
> attributes are not validated before and a malformed nlattr (e.g., length
> 0) could result in an OOB read that leaks heap dirty data.
> 
> This patch adds the nla_len check before accessing the nlattr data and
> error return EINVAL if the length check fails.

Reviewed-by: Chris Leech <cleech@redhat.com>

