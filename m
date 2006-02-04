From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8]  fusion - mptctl -adding asyn event notification support
Date: Sat, 4 Feb 2006 11:23:31 +0000
Message-ID: <20060204112331.GA28196@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F24369C@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:2280 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1946167AbWBDLXc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2006 06:23:32 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F24369C@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Feb 02, 2006 at 05:20:01PM -0700, Moore, Eric wrote:
> Adding aen support.

looks good, but it could use some codingstyle love:


+/*
+ * Event Handler function
+ */
+static int mptctl_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);

no need for the forward prototype, the function isn't used before it's
defined.

+struct fasync_struct *async_queue=NULL;

no need to initialize this to NULL because it'll go into .bss and will
be initializes automatically.  Also this variable can be static.

 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/* ASYNC Event Notification Support */
+static int
+mptctl_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
+{
+	u8 event;
+
+	event = le32_to_cpu(pEvReply->Event) & 0xFF;
+
+	dctlprintk(("%s() called\n", __FUNCTION__));
+	if(async_queue == NULL)

	if (async_queue == NULL)

or even better

	if (!async_queue)

+		ioc->aen_event_read_flag=1;

and please always put spaces around the '='

+static int
+mptctl_fasync(int fd, struct file *filep, int mode)
+{
+	MPT_ADAPTER	*ioc;
+
+	list_for_each_entry(ioc, &ioc_list, list)
+		ioc->aen_event_read_flag=0;

doesn't this need some locking?

