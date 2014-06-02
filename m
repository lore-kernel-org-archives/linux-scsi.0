From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] TARGET/sbc,loopback: Adjust command data length in case pi exists on the wire
Date: Mon, 02 Jun 2014 12:54:35 -0400
Message-ID: <yq1fvjn9rqs.fsf@sermon.lab.mkp.net>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
	<1401639581-20111-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1401639581-20111-3-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Sun, 1 Jun 2014 19:19:41 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: nab@linux-iscsi.org, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi,

Sagi> In various areas of the code, it is assumed that
Sagi> se_cmd-> data_length describes pure data. In case
Sagi> that protection information exists over the wire (protect bits is
Sagi> are on) the target core decrease the protection length from the
Sagi> data length (instead of each transport peeking in the cdb).

I completely agree with the notion of including PI in the transport byte
count.

Why do you open code the transfer length adjustment below?

+			/**
+			 * Adjust data_length to include
+			 * protection information
+			 **/
+			switch (sc->device->sector_size) {
+			case 512:
+				data_len += (data_len >> 9) * 8;
+				break;
+			case 1024:
+				data_len += (data_len >> 10) * 8;
+				break;
+			case 2048:
+				data_len += (data_len >> 11) * 8;
+				break;
+			case 4096:
+				data_len += (data_len >> 12) * 8;
+				break;
+			default:
+				data_len +=
+				(data_len >> ilog2(sc->device->sector_size)) * 8;
+			}

-- 
Martin K. Petersen	Oracle Linux Engineering
