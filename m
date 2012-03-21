From: adam radford <aradford@gmail.com>
Subject: Re: stuck in megaraid_sas.c megasas_adp_reset_gen2
Date: Wed, 21 Mar 2012 16:36:02 -0700
Message-ID: <CAHtARFGL0ibTZ=ADOL+x4akVvF-d1LjWoqW-WAv8_AeX+O3RdA@mail.gmail.com>
References: <201203211716.45418.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59560 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2CUXgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2012 19:36:05 -0400
In-Reply-To: <201203211716.45418.thomas@fjellstrom.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, Mar 21, 2012 at 4:16 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> I recently got an IBM M1015 (MegaRaid 9240-8i) card, and after getting a new
> motherboard, the system now boots, but the megaraid_sas driver seems to be
> getting stuck when trying to initialize the card.
>
> Looking through the source, it seems to be stuck in the megasas_adp_reset_gen2
> function, in the while loop at the end. Now, according to the code it can't
> actually get stuck there permanently, but it does take quite a while for the
> loop to finish, and the udev timeout messages to stop.
>
> I've looked around quite a bit, but haven't found any solutions thus far. If
> anyone could point me in the right direction I'd appreciate it.

If you are getting controller resets during driver load, you must not
be getting interrupts or firmware is not responding to the inquiry
roll-call.  Make sure you have the latest firmware.

The code at the end of megasas_adp_reset_gen2() just looks for
DIAG_RESET_ADAPTER flag to clear on the host diag register when
issuing a controller reset... that should happen almost immediately
unless there is a hardware or firmware issue.

Are you sure your 'new' motherboard is actually good ?

Can you move your megaraid 9240-8i into a 'known working' system and re-test ?

-Adam
