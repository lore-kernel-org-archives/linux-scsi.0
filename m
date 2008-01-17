From: "Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 17 Jan 2008 15:43:32 +0100
Message-ID: <e2e108260801170643o532888eajdbc13030af5814ef@mail.gmail.com>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	<478F246C.4040400@vlnb.net>
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	<478F2F46.9040103@vlnb.net>
	<20080117122956.GA3567@porcupine.cita.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <20080117122956.GA3567-Td5ZOp7sT3Xw02mFwxTg32+DJq1SqhBbsOSz5zK2v9k@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Robin Humble <robin.humble+stgt-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Jan 17, 2008 1:29 PM, Robin Humble <robin.humble+stgt-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org> wrote:

> was iscsiadm was pointed at the IP of the IPoIB interface on the target? I think tgtd requires that.
>
> how about setting the transport to be iser with eg.
>   iscsiadm --mode node --targetname <something> --portal <ipoib>:3260 --op update -n node.transport_name -v iser
>   iscsiadm --mode node --targetname <something> --portal <ipoib>:3260 --op update -n "node.conn[0].iscsi.HeaderDigest" -v None

Ah, thanks. After issuing these commands I get better performance with
STGT and iSER. The updated table is as follows:

                             STGT read             SCST read
                          performance (MB/s)   performance (MB/s)
Ethernet (1 Gb/s network)        77                    89
IPoIB (8 Gb/s network)           82                   229
SRP (8 Gb/s network)            N/A                   600
iSER (8 Gb/s network)           324                   N/A

Can we conclude that with the tested software versions SCST performs
significantly better than STGT on an InfiniBand network ?

Bart.
