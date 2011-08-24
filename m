From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 1/2] megaraid_sas: Remove the shutdown_controller call
Date: Wed, 24 Aug 2011 13:55:16 -0700
Message-ID: <CAHtARFF1iwy2NR1G01hFqBo2hoYxAbG+0DQ0UJNSS3JO_s5qbg@mail.gmail.com>
References: <1314200130-28890-1-git-send-email-thenzl@redhat.com>
	<1314200130-28890-2-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58465 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1HXUzS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2011 16:55:18 -0400
Received: by gxk21 with SMTP id 21so1183859gxk.19
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2011 13:55:17 -0700 (PDT)
In-Reply-To: <1314200130-28890-2-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, steve.masters@lsi.com, michael.benz@lsi.com, bo.yang@lsi.com

On Wed, Aug 24, 2011 at 8:35 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> Remove the call to megasas_shutdown_controller in the megasas_shutdown.

NACK.   The call to megasas_shutdown_controller() should not be removed.

megasas_shutdown_controller() does 3 things:

1. Cancels pended AEN command in firmware.
2. Cancels pended map update command in firmware.
3. Fires a MR_DCMD_CTRL_SHUTDOWN to notify firmware there was a clean
shutdown.  Without this, FW will think there was an 'unclean shutdown'
on the next restart, which will cause rebuilds and other background FW
activity to kick on every shutdown/reboot.

-Adam
