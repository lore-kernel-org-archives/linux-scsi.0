From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: Wed, 5 Mar 2003 00:12:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303050012.35309.oliver@neukum.name>
References: <20030303221532.GB1587@beaverton.ibm.com> <20030304123605.D6452@one-eyed-alien.net> <20030304222907.GA1252@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030304222907.GA1252@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>


> If a LLDD decided that it did not want any more devices added it can
> today fail calls to queuecommand or slave_alloc (which some already do).
> The LLDD may need to handle these in the future depending on what
> functions scsi_set_host_offline maybe racing with.

It seems to me that there's a race with scan_scsis() and scan_scsis_single()
which cannot be closed with failing queuecommand, as there's a window where
the INQUIRY has succeeded but has not yet been evaluated by the SCSI layer.
I am not quite sure how slave_alloc() is involved into this, but IMHO it's 
wrong to force LLDDs to know about devices if they are hotpluggable.
Could you clarify?

	Regards
		Oliver

