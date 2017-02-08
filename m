From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3] scsi/sd: release scan_mutex during sync_cache and
 start_stop
Date: Wed, 8 Feb 2017 22:58:11 +0000
Message-ID: <1486594677.16026.25.camel@sandisk.com>
References: <20170208225353.82334-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:24159 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdBHW72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 17:59:28 -0500
In-Reply-To: <20170208225353.82334-1-songliubraving@fb.com>
Content-Language: en-US
Content-ID: <37DE0DA245ACAF41861658018F26FA27@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "songliubraving@fb.com" <songliubraving@fb.com>

On Wed, 2017-02-08 at 14:53 -0800, Song Liu wrote:
> +	try_lock_scan_mutex = mutex_trylock(&shost->scan_mutex);

This is at least as bad as the approach of your previous patch because
whether or not this mutex_trylock() call succeeds not only depends on
whether or not the caller holds the scan_mutex but also on whether any
other thread accidentally holds that mutex. Please stop hacking and do
what Christoph proposed, namely address the caller of this method.

Bart.
