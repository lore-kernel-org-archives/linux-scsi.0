From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update 3/3] firewire: fw-sbp2: add support for multiple
	logical units per target
Date: Tue, 31 Jul 2007 20:37:16 +0200
Message-ID: <46AF815C.8050102@s5r6.in-berlin.de>
References: <tkrat.b8bfd55a441e870f@s5r6.in-berlin.de>	
	<tkrat.1c43b4e95fa76945@s5r6.in-berlin.de>	
	<tkrat.79f0390686f53591@s5r6.in-berlin.de>
	<59ad55d30707311045y3978a956wd4c090e9b579ae50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <59ad55d30707311045y3978a956wd4c090e9b579ae50@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Cc: =?ISO-8859-1?Q?gsberg?= <krh@redhat.com>, =?ISO-8859-1?Q?Kristian_H=F8?=@sc8-sf-spam2.sourceforge.net, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Kristian H=F8gsberg wrote:
> On 7/28/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>>  struct sbp2_logical_unit {
>>         struct sbp2_target *tgt;
>> +       struct list_head tgt_list;
> =

> I would call this link. I've consistently named all instances of
> struct list_head that are used as a list link either 'link'
> 'something_link'.  I find that it's a helpful convention for figuring
> out/remembering whether the field is a list head or the link part of
> an element in a list.

Yes, it's a good convention.  I somehow missed the pattern.

>> +               case SBP2_CSR_LOGICAL_UNIT_DIRECTORY:
>> +                       subdir =3D ci.p + value;
>> +                       if (subdir <=3D dev->config_rom + 5 ||
>> +                           subdir >=3D dev->config_rom + dev->config_ro=
m_length)
>> +                               fw_error("logical unit dir out of bounds=
\n");
> =

> This check isn't necessary, read_bus_info_block ensures that all
> blocks read are within the config rom area.

Right, fw_device_init fetched the directory for us, so we have it. #-)
-- =

Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D=3D=3D =3D=3D=3D=3D=3D
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
