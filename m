From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 0/3] Insert ATA transport objects in SCSI syfs topology.
Date: Sun, 7 Oct 2012 16:13:31 -0700
Message-ID: <CAA9_cmfOVuBQ0o0Nhaofi-N6wDL-FBqAjDc-CHwtcRr69hGNTg@mail.gmail.com>
References: <20120928062709.GA2091@mint-spring.sh.intel.com>
	<1349115776-17569-1-git-send-email-gwendal@google.com>
	<CAA9_cmdWHRLBru6hN1ibGK75rw3ZQbQ9TULRe-bU=3q4-fb+qw@mail.gmail.com>
	<CAMHSBOV8ghAV_RCRMPMHW0Gk8ugX6zWTp+aNnWUJ9tmiFeN8pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34989 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2JGXNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Oct 2012 19:13:33 -0400
In-Reply-To: <CAMHSBOV8ghAV_RCRMPMHW0Gk8ugX6zWTp+aNnWUJ9tmiFeN8pg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>
Cc: aaron.lu@intel.com, minggr@gmail.com, tj@kernel.org, jgarzik@pobox.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, Oct 4, 2012 at 9:56 AM, Gwendal Grignou <gwendal@google.com> wrote:
>> What's the benefit of this?
> + To unify ata transport sysfs topology with other scsi transport.

My concern is the thrash and breakage to switch the ordering around
given the (minor) growing pains injecting an ata_port into the device
path caused.  Although, it seems like Aaron has caught where this
reversal broke things at the cost of some additional special-casing (4
files changed, 25 insertions(+), 13 deletions(-)).  Patch 1 also
creates a problem for bisections as the code that assumes
<dev>/port/host will break.

I don't know... I'm all for consistency, but if the only justification
is to make the transports look the "same" we'll still have a glaring
transport difference between ata and sas.  In the sas case one
hba/host spanning all possible sas domains vs the ata case of a
guaranteed ata_port per "ata domain" relationship with at least one
host per port.  The "port" does live higher in the topology in the ata
case.

> + To easily map a ata_port with its associated scsi_host structure.

Not sure this is getting any easier.  There would now be three options
based on kernel version: look for the ata_port as a host attribute,
look at the host's parent, or look for the host's child.

--
Dan
