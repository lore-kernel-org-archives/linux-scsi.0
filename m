From: Luben Tuikov <luben@splentec.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Mon, 03 Mar 2003 13:17:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E639C1E.7060000@splentec.com>
References: <20030228111924.A32018@beaverton.ibm.com> <20030302085728.A11407@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
[cut]
>>+{
>>+	struct scsi_cmnd *scmd;
>>+	unsigned long flags;
>>+
>>+	spin_lock_irqsave(shost->host_lock, flags);
>>+	while (!shost->host_self_blocked
>>+	       && !list_empty(&shost->pending_queue)) {
> 
> 
> Linux codingstyle sais the && should be before the line break.

Actually there's a point to this.

Vision research has shown that the human eye doesn't scan/parse
more than 5% to 15% of the beginning of text lines when
searching for an item.

When a binary logical operator is on the continued (second)
line of the if test, the brain automatically assumes that
this is a _continuation_ of the logical condition -- since
no valid C language line starts _with_ a _binary logical op_.

But if the binary logical op were on the previous line, then
the next line would look just like a normal line and one would
_have_ to look at the previous line to see if it ends with `}' or
`;'.

There's a book called "C Style: Standards and Guidelines" by
David Straker, (C) 1992, Prentice Hall, ISBN: 0-13-116898-3.
More information can be found therein.

-- 
Luben


