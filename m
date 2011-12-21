From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC-v4 0/3] qla2xxx: v3.4 target mode LLD changes +
	tcm_qla2xxx fabric module
Date: Wed, 21 Dec 2011 18:11:35 +0100
Message-ID: <20111221171135.GA27369@lst.de>
References: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

I think the most important item is to sort out the mess around the old
generation qla23xx support.  The way the code currently sprinkles ifs
around that is a complete mess.  Given that the qla23xx support has as
far as I know zero test coverage, and has been EOLed by qlogic I see
no reason to keep it around.

Anyone disagreeing with that?

The other bit is sorting out handling of the full command queues in the
hardware.  Currently the target core does a blind retry after some delay,
which isn't a good idea.  I had an RFC patch on how to move it into the
driver, but I'll really need some help to find the proper place to wake
up any process waiting once we get free slots.
