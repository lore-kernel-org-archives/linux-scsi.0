From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 06 Jan 2003 15:49:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E19EBC4.6000601@splentec.com>
References: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl> <20030106112259.B13916@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Andries.Brouwer@cwi.nl, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

Matthew Dharm wrote:
> 
> Perhaps the "best" fix here is to simply make scsi_scan.c only send 36 byte
> inquiry requests if the bus is 'emulated'.  That would solve a world of
> problems....

When scsi_scan.c does it's own scanning for SCSI Core, maybe it's best to
ignore 36 < INQUIRY_DATA_LEN < 57, since this is just vendor specific
data and SCSI Core is not interested in it.

In descriptive-C this looks like this:

</issue a 36 byte buffer INQUIRY/>
</now dissect:/>

int bytes_got = max(bytes_requested - cmd->resid, 0);

if (31 < buffer[4] && buffer[4] < 52) {
	/* we don't care, do not issue another INQUIRY */	
else if (buffer[4] >= 52) {
	bytes_requested = 5+buffer[4];
	/* issue another INQUIRY to get the additional flags, */
	/* plus any version descriptors if available */
	</insert code here/>
	bytes_got = max(bytes_requested - cmd->resid, 0);
}

if (bytes_got != buffer[4]+5) {
	/* let's rely on the transport to have correctly set */
	/* cmd->resid and report a broken device server */
	</insert code here/>
}

/* Now we rely on bytes_got */

</rest of scanning code/>

-- 
Luben


