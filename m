From: Tom Yan <tom.ty89@gmail.com>
Subject: [regression] uas no longer queues commands since v4.5.2
Date: Sun, 22 May 2016 18:39:02 +0800
Message-ID: <CAGnHSEnR8n3-zxn767DEQv7eoDbA0cc3d_7xo8OZmO+g4jth+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:35001 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbcEVKjE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 May 2016 06:39:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, hdegoede@redhat.com, gregkh@linuxfoundation.org
Cc: linux-scsi@vger.kernel.org

With commit 198de51dbc3454d95b015ca0a055b673f85f01bb, uas no longer
set `queue_depth` with scsi_change_queue_depth(), so now `queue_depth`
of UAS drives are 1. Even though `can_queue` is set to
`devinfo->qdepth - 2`, but apparently that does not help, since I can
see performance impact.

Suppose limiting `can_queue` is the right way to fix this bug
(https://bugzilla.redhat.com/show_bug.cgi?id=1315013), do we really
need to eliminate scsi_change_queue_depth() at the same time though?
If so, how should we deal with the regression?
