From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 0/2] megaraid_sas: Fix an errant command from hw
Date: Wed, 24 Aug 2011 17:35:28 +0200
Message-ID: <1314200130-28890-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab1HXPfy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 11:35:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: steve.masters@lsi.com, michael.benz@lsi.com, aradford@gmail.com, bo.yang@lsi.com, Tomas Henzl <thenzl@redhat.com>

The following patch series provides a partial fix for a problem
seen in kdump after saving vmcore when the driver shuts down.

For unknown reason the card sends a command to the driver with a random values, 
we can then sometimes see this -
BUG: unable to handle kernel NULL pointer dereference at 00000090
....
The proper solution is to prevent this, maybe a firmware change is needed?

The first patch initializes the cmd field to a dummy value so the 'ghost' command
can be recognized.
The second patch removes the call to the megasas_shutdown_controller
in the megasas_shutdown_controller, because the errant cmd is sent while the controller
is shut down and it seems to be enough to only flush cache and disable interrupts.

Tomas
