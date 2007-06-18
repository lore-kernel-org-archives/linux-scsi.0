From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/5 v2] firewire: fw-sbp2: let SCSI shutdown commands
	through before logout
Date: Mon, 18 Jun 2007 20:21:19 +0200
Message-ID: <4676CD1F.3030907@s5r6.in-berlin.de>
References: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>	
	<tkrat.86a8cf28dc784b39@s5r6.in-berlin.de>	
	<1182180417.7928.13.camel@hinata.boston.redhat.com>	
	<4676B3FD.9010604@s5r6.in-berlin.de>	
	<tkrat.301a907417598815@s5r6.in-berlin.de>
	<59ad55d30706181046o5f089f3at1923748dec2d4b1a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <59ad55d30706181046o5f089f3at1923748dec2d4b1a@mail.gmail.com>
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
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Kristian H=F8gsberg wrote:
> On 6/18/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
...
>> +       scsi_remove_host(host);
>>         sbp2_send_management_orb(sd->unit, sd->node_id, sd->generation,
>>                                  SBP2_LOGOUT_REQUEST, sd->login_id, NULL=
);
>> -
>> -       scsi_remove_host(host);
>>         fw_core_remove_address_handler(&sd->address_handler);
>>         fw_notify("removed sbp2 unit %s\n", sd->unit->device.bus_id);
>>         put_device(&sd->unit->device);
> =

> This change looks right, but I just seem to remember I changed those
> lines around before... But I can't think of why your change shouldn't
> be correct, so let's just do that.
> =

> Signed-off-by: Kristian H=F8gsberg <krh@redhat.com>

I just dug around with qgit.  The logout has always been before removal
of the shost.  Maybe it was different before you submitted?  BTW the old
sbp2 driver logged out before host removal too, until Linux 2.6.13
inclusive.
-- =

Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D=3D- =3D--=3D-
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
