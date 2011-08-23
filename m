From: Ravi Shankar <ravi.v.shankar@oracle.com>
Subject: Re: mpt2sas: /sysfs sas_address entries do not show individual port
 sas addresses.
Date: Tue, 23 Aug 2011 12:39:28 -0700
Message-ID: <4E5401F0.7030303@oracle.com>
References: <4E4B9B04.10302@mpstor.com> <4E4BDFD7.3060109@interlog.com> <4E4D529F.9090908@oracle.com> <4E4D6D78.6040106@interlog.com> <4E4E5780.5000705@mpstor.com> <4E4EB442.20903@oracle.com> <4E5059F5.30908@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:59516 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab1HWTjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2011 15:39:44 -0400
In-Reply-To: <4E5059F5.30908@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Benjamin ESTRABAUD <be@mpstor.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


>
> spl2r02.pdf section 6.18.2 [link layer, SSP, Full duplex]:
>   "SSP is a full duplex protocol. An SSP phy may receive
>    an SSP frame or primitive in a connection while it is
>    transmitting an SSP frame or primitive in the same
>    connection. A wide SSP port may send and/or receive
>    SSP frames or primitives concurrently on different
>    connections (i.e., on different phys)."
>
> For a SCSI command like READ(10) a connection consumes
> one initiator phy and one target phy plus the pathway
> between them until it is closed. Typically a READ
> would have two connections: one to send the CDB and a
> second connection later to return the data and response
> (SCSI status and possibly sense data). For a spinning
> disk there could be milliseconds between those two
> connections; with an SSD less (do they use only one
> connection?).
>
> Due to the full duplex nature of a connection, DATA
> frames associated with a WRITE could overlap with DATA
> frames associated with an READ CDB sent earlier.
>
> In SAS-2, a single READ's maximum data rate is 6 Gbps.
> If a 2-phy wide link is available (along the whole pathway
> (see Figure 129 in spl2r02.pdf)) then two READs, sent one
> after the other or concurrently, could have their DATA
> frames returned concurrently. So the combined maximum
> data rate of the two READs would be 12 Gbps.
>
> Expanders don't change what is stated above. Pathways
> become an interconnection of links. A small latency is
> added to the opening of connections. And there is the
> possibility that no links are available to establish a
> connection (e.g. target to expander has available link(s)
> but all expander to initiator links are occupied).
>
>> Wondering has anyone measured performance under such scenario ?. It 
>> would be
>> great to see Expanders terminating SSP frames to over come
>> some of above limitation. Links between HBA and Expander and Expander 
>> to Disk
>> can be still Class 1.
>
> Not sure I follow. Expanders come into play when
> connections are being established.
>
If you've single Expander with multiple initiators and disks then there 
are no issue unless multiple initiators/targets
trying to access to same resources. There is no QoS (other than Path way 
count and Disconnect/Reconnect mode page)
enforced by the expander. Once you start daisy chaining expanders 
pathway between expanders will be bottle neck due
to connection oriented nature of SAS protocol. 
